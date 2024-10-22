import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    super.key,
    required this.date,
    required this.title,
  });

  final String date;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      width: 140,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 12,
            cornerSmoothing: 1,
          ),
        ),
        shadows: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(0x3f),
            blurRadius: 6,
          )
        ]
      ),
      child: Text(
        this.title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
    );
  }
}