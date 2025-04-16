import 'dart:async';

import 'package:uni/controller/fetchers/calendar_fetcher_json.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class CalendarProvider
    extends StateProviderNotifier<Map<AppLocale, List<CalendarEvent>>> {
  CalendarProvider()
      : super(cacheDuration: const Duration(days: 30), dependsOnSession: false);

  @override
  Future<Map<AppLocale, List<CalendarEvent>>> loadFromStorage(
    StateProviders stateProviders,
  ) async {
    final fetcher = CalendarFetcherJson();
    final ptEvents = await fetcher.getCalendar('pt');
    final enEvents = await fetcher.getCalendar('en');
    return {
      AppLocale.pt: ptEvents,
      AppLocale.en: enEvents,
    };
  }

  @override
  Future<Map<AppLocale, List<CalendarEvent>>> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    return state!;
  }
}
