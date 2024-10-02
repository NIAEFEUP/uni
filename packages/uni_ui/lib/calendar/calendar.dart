import 'package:flutter/material.dart';
import 'package:uni_ui/calendar/calendar_item.dart';

class Calendar extends StatelessWidget {
  const Calendar({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<CalendarItem> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: items,
      ),
    );
  }
}