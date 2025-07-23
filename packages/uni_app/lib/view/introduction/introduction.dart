import 'package:flutter/material.dart';
import 'package:uni/utils/navigation_items.dart';

class IntroductionScreenView extends StatefulWidget {
  const IntroductionScreenView({super.key});

  @override
  State<IntroductionScreenView> createState() => _IntroductionScreenViewState();
}

class _IntroductionScreenViewState extends State<IntroductionScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF280709),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Welcome to the Introduction Screen',
              style: TextStyle(color: Color(0xFFFFF5F3), fontSize: 24),
            ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    '/${NavigationItem.navPersonalArea.route}',
                  );
                }
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
