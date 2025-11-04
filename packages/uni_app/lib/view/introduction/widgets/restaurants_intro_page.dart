import 'package:flutter/material.dart';

class RestaurantsIntroPage extends StatefulWidget {
  const RestaurantsIntroPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<RestaurantsIntroPage> createState() => _RestaurantsIntroPageState();
}

class _RestaurantsIntroPageState extends State<RestaurantsIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Align(
          alignment: Alignment(0, -0.85),
          child: Text(
            'RESTAURANTS',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        const Align(
          alignment: Alignment(0, -0.7),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Discover campus dining options and menus',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.035, 0.5),
          child: Image.asset('assets/images/restaurants_intro.png', width: 260),
        ),
        Align(
          alignment: const Alignment(0, 0.95),
          child: GestureDetector(
            onTap: () {
              widget.pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
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
      ],
    );
  }
}
