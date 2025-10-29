import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';
import 'package:uni/model/providers/riverpod/library_occupation_provider.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/restaurant_provider.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni/view/home/widgets/connectivity_warning.dart';
import 'package:uni/view/home/widgets/exams/exam_home_card.dart';
import 'package:uni/view/home/widgets/library/library_home_card.dart';
import 'package:uni/view/home/widgets/restaurants/restaurant_home_card.dart';
import 'package:uni/view/home/widgets/schedule/schedule_home_card.dart';
import 'package:uni/view/home/widgets/tracking_banner.dart';
import 'package:uni/view/home/widgets/uni_logo.dart';
import 'package:uni/view/widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/theme.dart';

class HomePageView extends ConsumerStatefulWidget {
  const HomePageView({super.key});

  @override
  ConsumerState<HomePageView> createState() => HomePageViewState();
}

class HomePageViewState extends ConsumerState<HomePageView> {
  List<FavoriteWidgetType> favoriteCards =
      PreferencesController.getFavoriteCards();

  var _isBannerViewed = true;

  double appBarSize = 150;

  static Map<
    FavoriteWidgetType,
    AsyncNotifierProvider<CachedAsyncNotifier<dynamic>, dynamic>
  >
  typeToProvider = {
    FavoriteWidgetType.schedule: lectureProvider,
    FavoriteWidgetType.exams: examProvider,
    FavoriteWidgetType.library: libraryProvider,
    FavoriteWidgetType.restaurants: restaurantProvider,
  };

  @override
  void initState() {
    super.initState();
    checkBannerViewed();
  }

  Future<void> refreshPage(BuildContext context) async {
    for (final card in favoriteCards) {
      if (typeToProvider[card] != null) {
        await ref.read(typeToProvider[card]!.notifier).refreshRemote();
      }
    }
    setState(() {});
  }

  Future<void> checkBannerViewed() async {
    setState(() {
      _isBannerViewed = PreferencesController.isDataCollectionBannerViewed();
    });
  }

  Future<void> setBannerViewed() async {
    await PreferencesController.setDataCollectionBannerViewed(isViewed: true);
    await checkBannerViewed();
  }

  @override
  Widget build(BuildContext context) {
    final typeToCard = {
      FavoriteWidgetType.schedule: const ScheduleHomeCard(),
      FavoriteWidgetType.exams: const ExamHomeCard(),
      FavoriteWidgetType.library: const LibraryHomeCard(),
      FavoriteWidgetType.restaurants: const RestaurantHomeCard(),
      // FavoriteWidgetType.calendar: const CalendarHomeCard(), TODO: enable this when dates are properly formatted
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemOverlayStyles.base.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed:
              () => {
                Navigator.pushNamed(
                  context,
                  '/${NavigationItem.navEditPersonalArea.route}',
                ),
              },
          child: const UniIcon(UniIcons.edit),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: homeAppBar(context),
        bottomNavigationBar: const AppBottomNavbar(),
        body: RefreshIndicator(
          onRefresh: () => refreshPage(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: ListView.separated(
              itemCount: favoriteCards.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                if (index == 0) {
                  return Visibility(
                    visible: !_isBannerViewed,
                    child: TrackingBanner(setBannerViewed),
                  );
                } else {
                  return typeToCard[favoriteCards[index - 1]];
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize homeAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarSize),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF280709), Color(0xFF511515)],
            center: Alignment.topLeft,
            radius: 1.5,
            stops: [0, 1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UniLogo(iconColor: Colors.white),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConnectivityWarning(),
                          SizedBox(width: 10),
                          ProfileButton(),
                        ],
                      )
                    ],
                  ),
                ),
                DefaultConsumer<List<Lecture>>(
                  provider: lectureProvider,
                  builder: (context, ref, lectures) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (lectures.isNotEmpty && appBarSize != 200) {
                        setState(() {
                          appBarSize = 200;
                        });
                      }
                    });
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: ScheduleCard(
                        name: lectures[0].subject,
                        acronym: lectures[0].acronym,
                        room: lectures[0].room,
                        type: lectures[0].typeClass,
                        onTap: () {
                          final profile = ref.read(profileProvider);
                          final courseUnit = profile.value?.courseUnits
                              .firstWhereOrNull(
                                (unit) =>
                                    unit.abbreviation == lectures[0].acronym,
                              );
                          if (courseUnit != null &&
                              courseUnit.occurrId != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute<CourseUnitDetailPageView>(
                                builder:
                                    (context) =>
                                        CourseUnitDetailPageView(courseUnit),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                  hasContent: (lectures) => lectures.isNotEmpty,
                  nullContentWidget: const SizedBox.shrink(),
                  mapper:
                      (lectures) =>
                          lectures
                              .where(
                                (lecture) =>
                                    lecture.endTime.isAfter(DateTime.now()),
                              )
                              .toList(),
                  loadingWidget: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
