import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/connectivity_provider.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';
import 'package:uni/model/providers/riverpod/library_occupation_provider.dart';
import 'package:uni/model/providers/riverpod/news_provider.dart';
import 'package:uni/model/providers/riverpod/pedagogical_surveys_provider.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/restaurant_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni/view/home/widgets/calendar/calendar_home_card.dart';
import 'package:uni/view/home/widgets/connectivity_warning.dart';
import 'package:uni/view/home/widgets/exams/exam_home_card.dart';
import 'package:uni/view/home/widgets/library/library_home_card.dart';
import 'package:uni/view/home/widgets/news/news_home_card.dart';
import 'package:uni/view/home/widgets/pedagogical_surveys_info.dart';
import 'package:uni/view/home/widgets/restaurants/restaurant_home_card.dart';
import 'package:uni/view/home/widgets/schedule/schedule_home_card.dart';
import 'package:uni/view/home/widgets/tracking_banner.dart';
import 'package:uni/view/home/widgets/uni_logo.dart';
import 'package:uni/view/widgets/general_error_view.dart';
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
    FavoriteWidgetType.news: newsProvider,
  };

  @override
  void initState() {
    super.initState();
    checkBannerViewed();
  }

  Future<void> refreshPage(BuildContext context) async {
    final futures = <Future<void>>[];
    for (final card in favoriteCards) {
      final provider = typeToProvider[card];
      if (provider != null) {
        futures.add(ref.read(provider.notifier).refreshRemote());
      }
    }
    try {
      await Future.wait(futures);
    } catch (_) {}
    if (mounted) {
      setState(() {});
    }
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
      FavoriteWidgetType.calendar: const CalendarHomeCard(),
      FavoriteWidgetType.news: const NewsHomeCard(),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: homeAppBar(context),
        bottomNavigationBar: const AppBottomNavbar(),
        body: RefreshIndicator(
          onRefresh: () => refreshPage(context),
          child: ListView.separated(
            itemCount: favoriteCards.length + 2,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              if (index == 0) {
                return Visibility(
                  visible: !_isBannerViewed,
                  child: TrackingBanner(setBannerViewed),
                );
              } else if (index == favoriteCards.length + 1) {
                return Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      elevation: 2,
                      shadowColor: Theme.of(context).colorScheme.shadow,
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/${NavigationItem.navEditPersonalArea.route}',
                      );
                    },
                    icon: UniIcon(
                      UniIcons.edit,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    label: Text(
                      S.of(context).edit_homepage,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ),
                );
              } else {
                return typeToCard[favoriteCards[index - 1]];
              }
            },
          ),
        ),
      ),
    );
  }

  PreferredSize homeAppBar(BuildContext context) {
    final bool isOffline = ref.watch(connectivityProvider).value ?? false;
    final bool showSurveys = ref.watch(pedagogicalSurveysProvider);

    final now = DateTime.now();
    final week = Week(start: now);
    final lectureState = ref.watch(lectureProvider);

    final double appBarHeight = lectureState.when(
      data: (lectures) =>
          (lectures != null && lectures.isNotEmpty) ? 200.0 : 150.0,
      error: (_, _) => 200.0,
      loading: () => 150.0,
    );

    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.light
              ? RadialGradient(
                  colors: [
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.onTertiary,
                  ],
                  center: Alignment.topLeft,
                  radius: 2,
                  stops: const [0, 1],
                )
              : LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 1],
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const UniLogo(iconColor: Colors.white),
                      Row(
                        spacing: 16,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isOffline) const ConnectivityWarning(),
                          if (showSurveys) const PedagogicalSurveysInfo(),
                          const ProfileButton(),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: DefaultConsumer<List<Lecture>>(
                    provider: lectureProvider,
                    errorWidget: const GeneralErrorView(
                      textColor: Colors.white,
                    ),
                    builder: (context, ref, lectures) {
                      return ScheduleCard(
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
                                builder: (context) =>
                                    CourseUnitDetailPageView(courseUnit),
                              ),
                            );
                          }
                        },
                      );
                    },
                    hasContent: (lectures) => lectures
                        .where((lecture) => week.contains(lecture.startTime))
                        .isNotEmpty,
                    nullContentWidget: const SizedBox.shrink(),
                    mapper: (lectures) => lectures
                        .where(
                          (lecture) => lecture.endTime.isAfter(DateTime.now()),
                        )
                        .toList(),
                    loadingWidget: Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
