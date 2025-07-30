import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni/view/introduction/widgets/first_page.dart';

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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          FirstPage(pageController: _pageController),
          _buildSecondPage(),
          _buildThirdPage(),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    return const Center(
      child: Text(
        'Page 2',
        style: TextStyle(color: Color(0xFFFFF5F3), fontSize: 24),
      ),
    );
  }

  Widget _buildThirdPage() {
    return const Center(
      child: Text(
        'Page 3',
        style: TextStyle(color: Color(0xFFFFF5F3), fontSize: 24),
      ),
    );
  }
}
