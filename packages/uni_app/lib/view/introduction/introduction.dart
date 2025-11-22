import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni/view/introduction/widgets/exams_intro_page.dart';
import 'package:uni/view/introduction/widgets/first_page.dart';
import 'package:uni/view/introduction/widgets/map_intro_page.dart';
import 'package:uni/view/introduction/widgets/notifications_intro_page.dart';
import 'package:uni/view/introduction/widgets/restaurants_intro_page.dart';
import 'package:uni/view/introduction/widgets/schedule_intro_page.dart';
import 'package:uni/view/introduction/widgets/services_intro_page.dart';

class IntroductionScreenView extends StatefulWidget {
  const IntroductionScreenView({super.key});

  @override
  State<IntroductionScreenView> createState() => _IntroductionScreenViewState();
}

class _IntroductionScreenViewState extends State<IntroductionScreenView>
    with TickerProviderStateMixin {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF280709),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.95, -1),
                colors: [Color(0x705F171D), Color(0x02511515)],
                stops: [0, 1],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.1, 0.95),
                radius: 0.3,
                colors: [Color(0x705F171D), Color(0x02511515)],
                stops: [0, 1],
              ),
            ),
          ),
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              FirstPage(pageController: _pageController),
              ExamsIntroPage(pageController: _pageController),
              ScheduleIntroPage(pageController: _pageController),
              RestaurantsIntroPage(pageController: _pageController),
              ServicesIntroPage(pageController: _pageController),
              MapIntroPage(pageController: _pageController),
              NotificationsIntroPage(pageController: _pageController),
            ],
          ),
        ],
      ),
    );
  }
}
