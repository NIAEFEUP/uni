import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_calendar.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/session/flows/base/session.dart';

/// Fetch the school calendar from HTML
class CalendarFetcherHtml implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // TODO(bdmendes): Implement parsers for all faculties
    // and dispatch for different fetchers
    final url = '${NetworkRouter.getBaseUrl('feup')}'
        'web_base.gera_pagina?p_pagina=calend%c3%a1rio%20escolar';
    return [url];
  }

  Future<List<CalendarEvent>> getCalendar(Session session) async {
    final url = getEndpoints(session)[0];
    final response = NetworkRouter.getWithCookies(url, {}, session);
    final calendar = await response.then(getCalendarFromHtml);
    return calendar;
  }
}
