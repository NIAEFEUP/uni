import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni/view/home/widgets/uni_icon.dart';
import 'package:uni/view/home/widgets2/exam_card.dart';
import 'package:uni/view/home/widgets2/generic_homecard.dart';
import 'package:uni_ui/cards/schedule_card.dart';

class HomePageView2 extends StatefulWidget {
  const HomePageView2({super.key});

  @override
  State<StatefulWidget> createState() => HomePageView2State();
}

class HomePageView2State extends State<HomePageView2> {
  List<GenericHomecard> favoriteCards = [
    const ExamHomeCard(title: 'Exams'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: homeAppBar(context),
      bottomNavigationBar: const AppBottomNavbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListView(
          children: [...favoriteCards],
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
                    UniIcon(iconColor: Colors.white),
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
