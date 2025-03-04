import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/utils/favorite_widget_type.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni/view/home/widgets/exams/exam_home_card.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/library/library_home_card.dart';
import 'package:uni/view/home/widgets/restaurants/restaurant_home_card.dart';
import 'package:uni/view/home/widgets/schedule/schedule_home_card.dart';
import 'package:uni/view/home/widgets/tracking_banner.dart';
import 'package:uni/view/home/widgets/uni_logo.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/icons.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<StatefulWidget> createState() => HomePageViewState();
}

class HomePageViewState extends State<HomePageView> {
  List<FavoriteWidgetType> favoriteCards =
      PreferencesController.getFavoriteCards();

  bool isBannerViewed = true;

  double appBarSize = 100;

  static Map<FavoriteWidgetType, GenericHomecard> typeToCard = {
    FavoriteWidgetType.schedule: const ScheduleHomeCard(),
    FavoriteWidgetType.exams: const ExamHomeCard(),
    FavoriteWidgetType.library: const LibraryHomeCard(),
    FavoriteWidgetType.restaurants: const RestaurantHomeCard(),
    // FavoriteWidgetType.calendar: const CalendarHomeCard(), TODO: enable this when dates are properly formatted
  };

  @override
  void initState() {
    super.initState();
    checkBannerViewed();
  }

  Future<void> checkBannerViewed() async {
    setState(() {
      isBannerViewed = PreferencesController.isDataCollectionBannerViewed();
    });
  }

  Future<void> setBannerViewed() async {
    await PreferencesController.setDataCollectionBannerViewed(isViewed: true);
    await checkBannerViewed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListView.separated(
          itemCount: favoriteCards.length + 1,
          separatorBuilder: (_, __) => const SizedBox(
            height: 10,
          ),
          itemBuilder: (_, index) {
            if (index == 0) {
              return Visibility(
                visible: !isBannerViewed,
                child: TrackingBanner(setBannerViewed),
              );
            } else {
              return typeToCard[favoriteCards[index - 1]];
            }
          },
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
            colors: [
              Color(0xFF280709),
              Color(0xFF511515),
            ],
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
                      UniLogo(iconColor: Colors.white), // TODO: #1450
                      ProfileButton(),
                    ],
                  ),
                ),
                LazyConsumer<LectureProvider, List<Lecture>>(
                  builder: (context, lectures) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (lectures.isNotEmpty) {
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
                      ),
                    );
                  },
                  hasContent: (lectures) => lectures.isNotEmpty,
                  onNullContent: const SizedBox.shrink(),
                  mapper: (lectures) => lectures
                      .where(
                        (lecture) => lecture.endTime.isAfter(DateTime.now()),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
