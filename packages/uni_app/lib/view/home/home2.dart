import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/utils/favorite_widget_type2.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni/view/home/widgets/uni_logo.dart';
import 'package:uni/view/home/widgets2/calendar_home_card.dart';
import 'package:uni/view/home/widgets2/exam_home_card.dart';
import 'package:uni/view/home/widgets2/generic_home_card.dart';
import 'package:uni/view/home/widgets2/library_home_card.dart';
import 'package:uni/view/home/widgets2/restaurant_home_card.dart';
import 'package:uni/view/home/widgets2/schedule_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/icons.dart';

class HomePageView2 extends StatefulWidget {
  const HomePageView2({super.key});

  @override
  State<StatefulWidget> createState() => HomePageView2State();
}

class HomePageView2State extends State<HomePageView2> {
  List<FavoriteWidgetType2> favoriteCards =
      PreferencesController.getFavoriteCards2();

  double appBarSize = 100;

  static Map<FavoriteWidgetType2, GenericHomecard> typeToCard = {
    FavoriteWidgetType2.schedule: const ScheduleHomeCard(),
    FavoriteWidgetType2.exams: const ExamHomeCard(),
    FavoriteWidgetType2.library: const LibraryHomeCard(),
    FavoriteWidgetType2.restaurants: const RestaurantHomeCard(),
    FavoriteWidgetType2.calendar: const CalendarHomeCard(),
    // FavoriteWidgetType2.ucs:
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          shrinkWrap: true,
          itemCount: favoriteCards.length,
          separatorBuilder: (_, __) => const SizedBox(
            height: 10,
          ),
          itemBuilder: (_, index) => typeToCard[favoriteCards[index]],
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
              Expanded(
                child: LazyConsumer<LectureProvider, List<Lecture>>(
                  builder: (context, lectures) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (lectures.isNotEmpty) {
                        setState(() {
                          appBarSize = 200;
                        });
                      }
                    });
                    return Column(
                      // TODO: better implementation avoiding column
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScheduleCard(
                          name: lectures[0].subject,
                          acronym: 'TESTE',
                          room: lectures[0].room,
                          type: lectures[0].typeClass,
                        ),
                      ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
