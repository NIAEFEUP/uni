import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class ExamsIntroPage extends StatefulWidget {
  const ExamsIntroPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<ExamsIntroPage> createState() => _ExamsIntroPageState();
}

class _ExamsIntroPageState extends State<ExamsIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, -0.85),
          child: Text(
            S.of(context).exams.toUpperCase(),
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
              S.of(context).exams_intro_message,
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
          alignment: const Alignment(0, 0.25),
          child: Image.asset('assets/images/exams_intro.png', width: 250),
        ),
      ],
    );
  }
}
