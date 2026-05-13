import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class MapIntroPage extends StatefulWidget {
  const MapIntroPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<MapIntroPage> createState() => _MapIntroPageState();
}

class _MapIntroPageState extends State<MapIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, -0.85),
          child: Text(
            S.of(context).map.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFFFFF5F3),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0, -0.7),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.of(context).map_intro_message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFFFFF5F3),
                fontSize: 16,
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.035, 0.5),
          child: Image.asset('assets/images/map_intro.png', width: 260),
        ),
      ],
    );
  }
}
