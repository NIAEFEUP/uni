import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/calendar_fetcher_html.dart';
import 'package:uni/controller/local_storage/app_calendar_database.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class CalendarProvider extends StateProviderNotifier {
  List<CalendarEvent> _calendar = [];

  CalendarProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(days: 30));

  UnmodifiableListView<CalendarEvent> get calendar =>
      UnmodifiableListView(_calendar);

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    final Completer<void> action = Completer<void>();
    getCalendarFromFetcher(session, action);
    await action.future;
  }

  getCalendarFromFetcher(Session session, Completer<void> action) async {
    try {
      updateStatus(RequestStatus.busy);

      _calendar = await CalendarFetcherHtml().getCalendar(session);
      notifyListeners();

      final CalendarDatabase db = CalendarDatabase();
      db.saveCalendar(calendar);
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get the Calendar: ${e.toString()}');
      updateStatus(RequestStatus.failed);
    }
    action.complete();
  }

  @override
  Future<void> loadFromStorage() async {
    final CalendarDatabase db = CalendarDatabase();
    _calendar = await db.calendar();
  }
}
