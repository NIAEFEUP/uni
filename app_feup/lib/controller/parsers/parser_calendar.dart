import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';

import 'package:uni/model/utils/month.dart';
import 'package:uni/model/entities/calendar_event.dart';

Future<List<CalendarEvent>> getCalendarFromHtml(Response response) async {
  final document = parse(response.body);

  final List<Element> calendarHtml =
      document.getElementsByClassName('formularionome');
  final List<CalendarEvent> calendar = calendarHtml.map((row) {
    final name = row.children[0].text;
    final List<DateTime> dates = parseDate(row.children[1].text);
    return CalendarEvent(name, dates);
  }).toList();
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
    dates.add(dateWords[4] + parseMonth(dateWords[2]) + dateWords[0]);
  } else if (dateWords.length == 7) {
    // %d a %d de %m de %y
    dates.add(dateWords[6] + parseMonth(dateWords[4]) + dateWords[0]);
    dates.add(dateWords[6] + parseMonth(dateWords[4]) + dateWords[2]);
  } else if (dateWords.length == 9) {
    // %d de %m a %d de %m de %y
    dates.add(dateWords[8] + parseMonth(dateWords[2]) + dateWords[0]);
    dates.add(dateWords[8] + parseMonth(dateWords[6]) + dateWords[4]);
  } else if (dateWords.length == 11) {
    // %d de %m de %y a %d de %m de %y
    dates.add(dateWords[4] + parseMonth(dateWords[2]) + dateWords[0]);
    dates.add(dateWords[10] + parseMonth(dateWords[8]) + dateWords[6]);
  }

  return dates.map((date) => DateTime.parse(date)).toList();
}
