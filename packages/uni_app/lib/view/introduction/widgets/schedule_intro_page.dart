import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';

class ScheduleIntroPage extends StatefulWidget {
  const ScheduleIntroPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<ScheduleIntroPage> createState() => _ScheduleIntroPageState();
}

class _ScheduleIntroPageState extends State<ScheduleIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, -0.85),
          child: Text(
            S.of(context).schedule.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
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
              S.of(context).schedule_intro_message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Align(
          alignment: const Alignment(0.035, 0.5),
          child: Image.asset('assets/images/schedule_intro.png', width: 260),
        ),
      ],
    );
  }
}
