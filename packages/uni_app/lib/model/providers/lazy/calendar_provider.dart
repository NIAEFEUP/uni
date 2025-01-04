import 'dart:async';

import 'package:uni/controller/fetchers/calendar_fetcher_html.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class CalendarProvider extends StateProviderNotifier<List<CalendarEvent>> {
  CalendarProvider() : super(cacheDuration: const Duration(days: 30));

  @override
  Future<List<CalendarEvent>> loadFromStorage(
    StateProviders stateProviders,
  ) async {
    return Database().calendarEvents;
  }

  @override
  Future<List<CalendarEvent>> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    final session = stateProviders.sessionProvider.state!;
    final calendarEvents = await CalendarFetcherHtml().getCalendar(session);
    Database().saveCalendarEvents(calendarEvents);
    return calendarEvents;
  }
}
