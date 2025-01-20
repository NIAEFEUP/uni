import 'package:flutter/material.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/view/home/widgets2/generic_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/calendar/calendar.dart';
import 'package:uni_ui/calendar/calendar_item.dart';

class CalendarHomeCard extends GenericHomecard {
  const CalendarHomeCard({super.key, required super.title});

  @override
  void onClick(BuildContext context) {}

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<CalendarProvider, List<CalendarEvent>>(
      builder: (context, events) {
        return Calendar(
          items: buildCalendarItems(events),
        );
      },
      hasContent: (events) => events.isNotEmpty,
      onNullContent: const Center(
        child: Text(
          'Nenhum evento encontrado',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  List<CalendarItem> buildCalendarItems(List<CalendarEvent> events) {
    final items = events
        .map((event) => CalendarItem(
              eventName: event.name,
            ))
        .toList();

    return items; // TODO: wait for calendar events date regex
  }
}


/*
const CalendarItem({
    super.key,
    required this.eventName,
    this.eventPeriod,
    this.endYear,
    this.onTap,
  });
*/
