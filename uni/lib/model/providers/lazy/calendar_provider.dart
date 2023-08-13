import 'dart:async';
import 'dart:collection';

import 'package:uni/controller/fetchers/calendar_fetcher_html.dart';
import 'package:uni/controller/local_storage/app_calendar_database.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class CalendarProvider extends StateProviderNotifier {
  CalendarProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(days: 30));
  List<CalendarEvent> _calendar = [];

  UnmodifiableListView<CalendarEvent> get calendar =>
      UnmodifiableListView(_calendar);

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchCalendar(session);
  }

  Future<void> fetchCalendar(Session session) async {
    try {
      _calendar = await CalendarFetcherHtml().getCalendar(session);

      final db = CalendarDatabase();
      unawaited(db.saveCalendar(calendar));

      updateStatus(RequestStatus.successful);
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }

  @override
  Future<void> loadFromStorage() async {
    final db = CalendarDatabase();
    _calendar = await db.calendar();
  }
}
