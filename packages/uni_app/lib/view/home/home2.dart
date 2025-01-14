import 'package:flutter/material.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/profile_button.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/top_navigation_bar.dart';
import 'package:uni/view/home/widgets/uni_icon.dart';
import 'package:uni_ui/cards/exam_card.dart';

class HomePageView2 extends StatefulWidget {
  const HomePageView2({super.key});

  @override
  State<StatefulWidget> createState() => HomePageView2State();
}

class HomePageView2State extends State<HomePageView2> {
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
      body: const Text('hello'),
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
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UniIcon(iconColor: Colors.white),
                  ProfileButton(),
                ],
              ),
              ExamCard(
                name: 'Teste',
                acronym: 'TE',
                rooms: ['B223', 'B222'],
                type: 'MT',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
