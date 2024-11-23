import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key, required this.nextScreen});

  final Widget nextScreen;

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  late Future<void> _loadNextScreen;

  @override
  void initState() {
    super.initState();
    _loadNextScreen = _initializeNextScreen();
  }

  Future<void> _initializeNextScreen() async {
    await Future<void>.delayed(const Duration(milliseconds: 3500));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFF280709),
        body: FutureBuilder<void>(
          future: _loadNextScreen,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return widget.nextScreen;
            } else {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'logo',
                          flightShuttleBuilder: (
                            flightContext,
                            animation,
                            flightDirection,
                            fromHeroContext,
                            toHeroContext,
                          ) {
                            return ScaleTransition(
                              scale: animation.drive(
                                Tween(begin: 0, end: 1).chain(
                                  CurveTween(curve: Curves.easeInOut),
                                ) as Animatable<double>,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/logo_dark.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFFFF5F3),
                                  BlendMode.srcIn,
                                ),
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/images/logo_dark.svg',
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFFFF5F3),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'by NIAEFEUP',
                          style: TextStyle(
                            color: Color(0xFFFFF5F3),
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.95, -1),
                        colors: [
                          Color(0x705F171D),
                          Color(0x02511515),
                        ],
                        stops: [0, 1],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0.1, 0.95),
                        radius: 0.3,
                        colors: [
                          Color(0x705F171D),
                          Color(0x02511515),
                        ],
                        stops: [0, 1],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
