import 'dart:async';

import 'package:uni/controller/fetchers/calendar_fetcher_json.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/localized_events.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class CalendarProvider extends StateProviderNotifier<LocalizedEvents> {
  CalendarProvider()
    : super(cacheDuration: const Duration(days: 30), dependsOnSession: false);

  @override
  Future<LocalizedEvents> loadFromStorage(StateProviders stateProviders) async {
    final fetcher = CalendarFetcherJson();
    final ptEvents = await fetcher.getCalendar('pt');
    final enEvents = await fetcher.getCalendar('en');
    return LocalizedEvents(
      events: {AppLocale.pt: ptEvents, AppLocale.en: enEvents},
    );
  }

  @override
  Future<LocalizedEvents> loadFromRemote(StateProviders stateProviders) async {
    return state!;
  }
}
