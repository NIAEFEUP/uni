import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';

import 'package:uni/model/utils/month.dart';
import 'package:uni/model/entities/calendar_event.dart';

Future<List<CalendarEvent>> getCalendarFromHtml(Response response) async {
  final document = parse(response.body);

  final List<Element> calendarHtml =
      document.querySelectorAll('tr > *');
  final List<CalendarEvent> calendar = [];
  for (int i = 0; i < calendarHtml.length ; i++) {
    final name = calendarHtml[i].text;
    i++;
    final List<DateTime> dates = parseDate(calendarHtml[i].text);
    calendar.add(CalendarEvent(name, dates));
  }

  /*final List<CalendarEvent> calendar = calendarHtml.map((row) {
    final name = row.children[0].text;
    final List<DateTime> dates = parseDate(row.children[1].text);
    return CalendarEvent(name, dates);
  }).toList();*/
  return calendar;
}

/// Parse the different date formats
List<DateTime> parseDate(String dateString) {
  final List<String> dates = [];
  final List<String> dateWords = dateString.split(' ');

  if (dateWords.length < 5) {
    return [];
  } else if (dateWords.length == 5) {
    // '%d de %m de %y'
    dates.add(dateWords[4] + parseMonth(dateWords[2]) +
      dateWords[0].padLeft(2, '0'));
  } else if (dateWords.length == 6) {
    if (dateWords[0] == 'até') {
      // 'até %d de %m de %y'
      dates.add(dateWords[5] + parseMonth(dateWords[3]) +
        dateWords[1].padLeft(2, '0'));
    } else {
      // '%d a %d %m de %y'
      dates.add(dateWords[5] + parseMonth(dateWords[3]) +
        dateWords[0].padLeft(2, '0'));
      dates.add(dateWords[5] + parseMonth(dateWords[3]) +
        dateWords[2].padLeft(2, '0'));
    }
  } else if (dateWords.length == 7) {
    if (dateWords[1] == 'a') {
      // %d a %d de %m de %y
      dates.add(dateWords[6] + parseMonth(dateWords[4]) + 
        dateWords[0].padLeft(2, '0'));
      dates.add(dateWords[6] + parseMonth(dateWords[4]) + 
        dateWords[2].padLeft(2, '0'));
    }
    else {
      // %d %m a %d %m de %y
      dates.add(dateWords[6] + parseMonth(dateWords[1]) + 
        dateWords[0].padLeft(2, '0'));
      dates.add(dateWords[6] + parseMonth(dateWords[4]) + 
        dateWords[3].padLeft(2, '0'));
    }
  } else if (dateWords.length == 9) {
    // %d de %m a %d de %m de %y
    dates.add(dateWords[8] + parseMonth(dateWords[2]) + 
      dateWords[0].padLeft(2, '0'));
    dates.add(dateWords[8] + parseMonth(dateWords[6]) + 
      dateWords[4].padLeft(2, '0'));
  } else if (dateWords.length == 11) {
    // %d de %m de %y a %d de %m de %y
    dates.add(dateWords[4] + parseMonth(dateWords[2]) + 
      dateWords[0].padLeft(2, '0'));
    dates.add(dateWords[10] + parseMonth(dateWords[8]) + 
      dateWords[6].padLeft(2, '0'));
  }

  return dates.map((date) => DateTime.parse(date)).toList();
}
