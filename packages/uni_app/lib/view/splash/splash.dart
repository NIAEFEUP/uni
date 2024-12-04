import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni/main.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 1500),
      () async {
        if (mounted) {
          final route = await firstRoute();
          if (context.mounted) {
            await Navigator.pushReplacementNamed(context, route);
          }
        }
      }
    );
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF280709),
      body: Stack(
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
                        Tween(begin: 0.0, end: 1.0).chain(
                          CurveTween(curve: Curves.easeInOut),
                        ),
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
      ),
    );
  }
}
