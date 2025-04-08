import 'dart:async';

import 'package:uni/controller/fetchers/calendar_fetcher_json.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class CalendarProvider extends StateProviderNotifier<List<CalendarEvent>> {
  CalendarProvider() : super(cacheDuration: const Duration(days: 0), dependsOnSession: false);

  @override
  Future<List<CalendarEvent>> loadFromStorage(
    StateProviders stateProviders,
  ) async {
    return CalendarFetcherJson().getCalendar('pt'); // TODO: 'pt'/'en'
  }

  @override
  Future<List<CalendarEvent>> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    return state!;
  }
}
