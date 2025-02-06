import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/app_locale.dart';

class DatesTile extends StatelessWidget {
  const DatesTile({
    required this.date,
    required this.start,
    required this.end,
    required this.locale,
    super.key,
  });
  final String date;
  final AppLocale locale;
  final DateTime? start;
  final DateTime? end;

  @override
  Widget build(BuildContext context) {
    if (date == 'TBD') {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          date,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      final eventperiod = eventPeriod();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            eventperiod[0],
            style: const TextStyle(
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            eventperiod[1],
            style: TextStyle(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 11,
            ),
          ),
        ],
      );
    }
  }

  List<String> eventPeriod() {
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
        ..add('the date')
        ..add(date);
      return period;
    }
    year = start!.year.toString();
    month = shortMonth(start!);
    day = start!.day.toString();
    if (end == null) {
      timePeriod = '$day $month';
      period
        ..add(timePeriod)
        ..add(year);
      return period;
    }
    day1 = end!.day.toString();
    year1 = end!.year.toString();
    month1 = shortMonth(end!);
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
