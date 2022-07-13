import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_calendar.dart';
import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/entities/session.dart';

/// Fetch the school calendar from HTML
class CalendarFetcherHtml {
  List<String> getEndpoints(Session session) {
    // TO DO: Implement parsers for all faculties
    // and dispatch for different fetchers
    final String url = NetworkRouter.getBaseUrl('feup')
      + 'web_base.gera_pagina?p_pagina=página%20estática%20genérica%20106';
    return [url];
  }

  Future<List<CalendarEvent>> getCalendar(Store<AppState> store) async {
    final Session session = store.state.content['session'];
    final String url = getEndpoints(session)[0];
    final Future<Response> response = NetworkRouter.getWithCookies(
      url, {}, session);
    final List<CalendarEvent> calendar = 
     await response.then((response) => getCalendarFromHtml(response));
    return calendar;
  }

}