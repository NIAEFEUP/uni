import 'package:flutter/material.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni_ui/cards/timeline_card.dart';

// TODO(thePeras): This class should be extracted up
class RowFormat extends StatelessWidget {
  const RowFormat({super.key, required this.event, required this.locale});
  final CalendarEvent event;
  final AppLocale locale;

  @override
  Widget build(BuildContext context) {
    final eventperiod = event.formattedPeriod;

    return TimelineItem(
      title: eventperiod[0],
      subtitle: eventperiod[1],
      titleWidth: 90,
      card: Text(
        event.name,
        style: Theme.of(context).textTheme.headlineSmall,
        maxLines: 5,
      ),
    );
  }
}
