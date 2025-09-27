import 'package:flutter/material.dart';

class ExamsIntroPage extends StatefulWidget {
  const ExamsIntroPage({super.key});

  @override
  State<ExamsIntroPage> createState() => _ExamsIntroPageState();
}

class _ExamsIntroPageState extends State<ExamsIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Align(
          alignment: Alignment(0, -0.85),
          child: Text(
            'EXAMS',
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
              'Stay always updated with your exam schedules',
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
          child: Image.asset('assets/images/exams_intro.png', width: 260),
        ),
      ],
    );
  }
}
