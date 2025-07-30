import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni/utils/navigation_items.dart';

class IntroductionScreenView extends StatefulWidget {
  const IntroductionScreenView({super.key});

  @override
  State<IntroductionScreenView> createState() => _IntroductionScreenViewState();
}

class _IntroductionScreenViewState extends State<IntroductionScreenView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _logoController;
  late AnimationController _image1Controller;
  late AnimationController _image2Controller;
  late AnimationController _buttonController;

  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _image1FadeAnimation;
  late Animation<Offset> _image1SlideAnimation;
  late Animation<double> _image2FadeAnimation;
  late Animation<Offset> _image2SlideAnimation;
  late Animation<double> _buttonFadeAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _pageController = PageController();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _image1Controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _image2Controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _image1FadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _image1Controller, curve: Curves.easeOut),
    );

    _image1SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _image1Controller, curve: Curves.easeOut),
    );

    _image2FadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _image2Controller, curve: Curves.easeOut),
    );

    _image2SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _image2Controller, curve: Curves.easeOut),
    );

    _buttonFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    unawaited(_logoController.forward());

    unawaited(Future<void>.delayed(const Duration(milliseconds: 300)));
    unawaited(_image1Controller.forward());

    unawaited(Future<void>.delayed(const Duration(milliseconds: 200)));
    unawaited(_image2Controller.forward());

    unawaited(Future<void>.delayed(const Duration(milliseconds: 200)));
    unawaited(_buttonController.forward());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _logoController.dispose();
    _image1Controller.dispose();
    _image2Controller.dispose();
    _buttonController.dispose();
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
        children: [_buildFirstPage(), _buildSecondPage(), _buildThirdPage()],
      ),
    );
  }

  Widget _buildFirstPage() {
    return Stack(
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
        Align(
          alignment: const Alignment(0, -0.85),
          child: AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _logoFadeAnimation,
                child: SlideTransition(
                  position: _logoSlideAnimation,
                  child: SvgPicture.asset(
                    'assets/images/logo_dark.svg',
                    width: 120,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFFF5F3),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: const Alignment(1, -0.1),
          child: AnimatedBuilder(
            animation: _image2Controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _image2FadeAnimation,
                child: SlideTransition(
                  position: _image2SlideAnimation,
                  child: Image.asset('assets/images/intro2.png', width: 220),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: const Alignment(-1, 0.3),
          child: AnimatedBuilder(
            animation: _image1Controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _image1FadeAnimation,
                child: SlideTransition(
                  position: _image1SlideAnimation,
                  child: Image.asset('assets/images/intro1.png', width: 220),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.9),
          child: AnimatedBuilder(
            animation: _buttonController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _buttonFadeAnimation,
                child: SlideTransition(
                  position: _buttonSlideAnimation,
                  child: GestureDetector(
                    onTap: () async {
                      if (context.mounted) {
                        await Navigator.pushReplacementNamed(
                          context,
                          '/${NavigationItem.navPersonalArea.route}',
                        );
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment(-0.24, -0.31),
                          colors: [Color(0xFF280709), Color(0xFF461014)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0xBF996B6E),
                            blurRadius: 22,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFFFFF5F3),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
