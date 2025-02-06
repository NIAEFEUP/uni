import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final eventperiod = eventPeriod(event.date, event.start, event.finish);

    return TimelineItem(
      title: eventperiod[0],
      subtitle: eventperiod[1],
      card: Text(
        event.name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
        maxLines: 5,
      ),
    );
  }

  // TODO(thePeras): This shoudn't exist here
  List<String> eventPeriod(String date, DateTime? start, DateTime? end) {
    final period = <String>[];
    String timePeriod;
    String month;
    String? month1;
    String day;
    String? day1;
    String year;
    String? year1;
    if (start == null) {
      period
        ..add(date)
        ..add('');
      return period;
    }
    year = start.year.toString();
    month = shortMonth(start);
    day = start.day.toString();
    if (end == null) {
      timePeriod = '$day $month';
      period
        ..add(timePeriod)
        ..add(year);
      return period;
    }
    day1 = end.day.toString();
    year1 = end.year.toString();
    month1 = shortMonth(end);
    if (year == year1 && month1 == month) {
      timePeriod = '$day-$day1 $month';
      period
        ..add(timePeriod)
        ..add(year);
      return period;
    }
    if (year == year1 && month1 != month) {
      timePeriod = '$day $month-$day1 $month1';
      period
        ..add(timePeriod)
        ..add(year);
      return period;
    }
    if (year1 != year) {
      timePeriod = '$day $month-$day1 $month1';
      period
        ..add(timePeriod)
        ..add(year);
      return period;
    }
    period
      ..add('the date')
      ..add(date);
    return period;
  }

  String shortMonth(DateTime date) {
    return DateFormat.MMM(locale.localeCode.languageCode)
        .format(date)
        .replaceFirst('.', '');
  }
}
