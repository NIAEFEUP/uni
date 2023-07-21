import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_calendar.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/entities/session.dart';

/// Fetch the school calendar from HTML
class CalendarFetcherHtml implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // TO DO: Implement parsers for all faculties
    // and dispatch for different fetchers
    final url = '${NetworkRouter.getBaseUrl('feup')}'
        'web_base.gera_pagina?p_pagina=página%20estática%20genérica%20106';
    return [url];
  }

  Future<List<CalendarEvent>> getCalendar(Session session) async {
    final url = getEndpoints(session)[0];
    final response = NetworkRouter.getWithCookies(url, {}, session);
    final calendar = await response.then(getCalendarFromHtml);
    return calendar;
  }
}
