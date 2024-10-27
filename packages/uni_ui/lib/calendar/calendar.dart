import 'package:flutter/material.dart';
import 'package:uni_ui/calendar/calendar_item.dart';

class CalendarLine extends StatelessWidget {
  const CalendarLine({
    super.key,
    required this.calendarItemsCount,
  });

  final int calendarItemsCount;

  @override
  Widget build(BuildContext context) {
    if (calendarItemsCount == 0) return Container();

    return Container(
      margin: EdgeInsets.only(top: 44),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 4,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
            ),
          ),
          ...List.filled(
            calendarItemsCount - 1,
            Container(
              width: 120,
              height: 4,
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Container(
            width: 60,
            height: 4,
            margin: EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(2),
                bottomLeft: Radius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  const Calendar({
    super.key,
    required this.items,
  });

  final List<CalendarItem> items;

  @override
  Widget build(BuildContext context) {
    // Row + SingleChildScrollView is used, instead of ListView, to avoid
    // the widget from expanding vertically
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items,
            ),
            CalendarLine(
              calendarItemsCount: items.length,
            ),
          ],
        ));
  }
}
