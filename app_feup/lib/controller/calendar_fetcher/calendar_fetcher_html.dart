import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_calendar.dart';
import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/entities/session.dart';

/// Fetch the school calendar from HTML
class CalendarFetcherHtml {
  Future<List<CalendarEvent>> getCalendar(Store<AppState> store) async {
    final String url = NetworkRouter.getBaseUrlFromSession(
      store.state.content['session']) + 
      'web_base.gera_pagina?p_pagina=página%20estática%20genérica%20106';
    final Session session = store.state.content['session'];
    final Future<Response> response = NetworkRouter.getWithCookies(
      url, {}, session);
    final List<CalendarEvent> calendar = 
     await response.then((response) => getCalendarFromHtml(response));
    return calendar;
  }

}