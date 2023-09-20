import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/model/entities/calendar_event.dart';

Future<List<CalendarEvent>> getCalendarFromHtml(Response response) async {
  final document = parse(response.body);

  final calendarHtml = document.querySelectorAll('tr');

  return calendarHtml
      .map(
        (event) => CalendarEvent(
          event.children[0].innerHtml,
          event.children[1].innerHtml,
        ),
      )
      .where(
        (event) =>
            event.name.trim() != '&nbsp;' && event.date.trim() != '&nbsp;',
      )
      .toList();
}
