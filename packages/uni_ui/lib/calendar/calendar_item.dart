import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    super.key,
    required this.eventName,
    required this.eventPeriod,
  });

  final String eventName;
  final DateTimeRange eventPeriod;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          parsePeriod(this.eventPeriod),
          style: TextStyle(
            fontSize: 15,
            height: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          this.eventPeriod.end.year.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.outline,
            fontSize: 11,
          ),
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 10),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4.0,
                ),
              ),
            ),
            Container(
              width: 4,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3)),
                shape: BoxShape.rectangle,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 18),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3),
                          bottomRight: Radius.circular(3),
                        )),
                  ),
                  SizedBox(width: 30),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3),
                        bottomLeft: Radius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
            ],
          ),
          child: Text(
            this.eventName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }

  static String monthToString(int month) {
    // TODO: Support English
    const strMonths = [
      "Jan",
      "Fev",
      "Mar",
      "Abr",
      "Mai",
      "Jun",
      "Jul",
      "Ago",
      "Set",
      "Out",
      "Nov",
      "Dec"
    ];
    return strMonths[month - 1];
  }

  static String parsePeriod(DateTimeRange period) {
    final start = period.start, end = period.end;

    if (start.month == end.month) {
      return start.day == end.day
          ? "${start.day} ${monthToString(start.month)}."
          : "${start.day} - ${end.day} ${monthToString(start.month)}.";
    } else {
      return "${start.day} ${monthToString(start.month)} - ${end.day} ${monthToString(end.month)}";
    }
  }
}
