import 'dart:async';

import 'package:uni/controller/fetchers/calendar_fetcher_json.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class CalendarProvider extends StateProviderNotifier<List<CalendarEvent>> {
  CalendarProvider() : super(cacheDuration: const Duration(days: 0));

  //TODO: Should we use db?
  @override
  Future<List<CalendarEvent>> loadFromStorage(
    StateProviders stateProviders,
  ) async {
    try {
      final calendar = await CalendarFetcherJson()
          .getCalendar('pt'); // TODO: get locale from state
      return calendar;
    } catch (e, stackTrace) {
      return [];
    }
  }

  @override
  Future<List<CalendarEvent>> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    try {
      final session = stateProviders.sessionProvider.state!;
      final calendar = await CalendarFetcherJson().getCalendar('pt');
      return calendar;
    } catch (e, stackTrace) {
      return [];
    }
  }
}
