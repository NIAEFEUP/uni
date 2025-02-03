import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/utils/favorite_widget_type2.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni/view/home/widgets/uni_icon.dart' as logo;
import 'package:uni/view/home/widgets2/calendar_home_card.dart';
import 'package:uni/view/home/widgets2/exam_home_card.dart';
import 'package:uni/view/home/widgets2/generic_home_card.dart';
import 'package:uni/view/home/widgets2/library_home_card.dart';
import 'package:uni/view/home/widgets2/schedule_home_card.dart';
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

  static Map<FavoriteWidgetType2, GenericHomecard> typeToCard = {
    FavoriteWidgetType2.schedule: const ScheduleHomeCard(),
    FavoriteWidgetType2.exams: const ExamHomeCard(),
    FavoriteWidgetType2.library: const LibraryHomeCard(),
    // FavoriteWidgetType2.restaurants:
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
      preferredSize: const Size.fromHeight(200),
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
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    logo.UniIcon(iconColor: Colors.white),
                    ProfileButton(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  // TODO: better implementation avoiding column
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScheduleCard(
                      name: 'Computer Laboratory',
                      acronym: 'LCOM',
                      room: 'B315',
                      type: 'MT',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
