import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';

import 'package:uni/model/entities/calendar_event.dart';

Future<List<CalendarEvent>> getCalendarFromHtml(Response response) async {
  final document = parse(response.body);

  final List<Element> calendarHtml = document.querySelectorAll('tr');

  return calendarHtml
      .map((event) => CalendarEvent(
          event.children[0].innerHtml, event.children[1].innerHtml))
      .toList();
}
