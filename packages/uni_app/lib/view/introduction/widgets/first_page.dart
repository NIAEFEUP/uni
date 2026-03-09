import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _image1Controller;
  late AnimationController _image2Controller;

  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _image1FadeAnimation;
  late Animation<Offset> _image1SlideAnimation;
  late Animation<double> _image2FadeAnimation;
  late Animation<Offset> _image2SlideAnimation;

  @override
  void initState() {
    super.initState();
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

    _image1SlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _image1Controller, curve: Curves.easeOut),
        );

    _image2FadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _image2Controller, curve: Curves.easeOut),
    );

    _image2SlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _image2Controller, curve: Curves.easeOut),
        );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    unawaited(_logoController.forward());

    unawaited(Future<void>.delayed(const Duration(milliseconds: 300)));
    unawaited(_image1Controller.forward());

    unawaited(Future<void>.delayed(const Duration(milliseconds: 200)));
    unawaited(_image2Controller.forward());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _image1Controller.dispose();
    _image2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
      ],
    );
  }
}
