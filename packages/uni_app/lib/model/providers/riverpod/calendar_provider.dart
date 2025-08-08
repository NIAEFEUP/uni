import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/calendar_fetcher_json.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/localized_events.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';

final calendarProvider =
    AsyncNotifierProvider<CalendarProvider, LocalizedEvents?>(
      CalendarProvider.new,
    );

class CalendarProvider extends CachedAsyncNotifier<LocalizedEvents> {
  @override
  Duration? get cacheDuration => const Duration(days: 30);

  @override
  Future<LocalizedEvents> loadFromStorage() async {
    final fetcher = CalendarFetcherJson();
    final ptEvents = await fetcher.getCalendar('pt');
    final enEvents = await fetcher.getCalendar('en');

    return LocalizedEvents(
      events: {AppLocale.pt: ptEvents, AppLocale.en: enEvents},
    );
  }

  @override
  Future<LocalizedEvents> loadFromRemote() async {
    return state.value!;
  }
}
