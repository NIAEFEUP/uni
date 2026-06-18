import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/events_fetcher/calendar_fetcher_json.dart';
import 'package:uni/controller/fetchers/events_fetcher/event_fetcher_niddle.dart';
import 'package:uni/controller/fetchers/events_fetcher/events_fetcher_constants.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/localized_events.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final calendarProvider =
    AsyncNotifierProvider<CalendarNotifier, LocalizedEvents?>(
      CalendarNotifier.new,
    );

class CalendarNotifier extends CachedAsyncNotifier<LocalizedEvents> {
  CalendarNotifier({
    CalendarFetcherJson? jsonFetcher,
    EventFetcherNiddle? niddleFetcher,
  })  : _jsonFetcher = jsonFetcher,
        _niddleFetcher = niddleFetcher;

  final CalendarFetcherJson? _jsonFetcher;
  final EventFetcherNiddle? _niddleFetcher;

  CalendarFetcherJson get jsonFetcher => _jsonFetcher ?? CalendarFetcherJson();
  EventFetcherNiddle get niddleFetcher =>
      _niddleFetcher ?? EventFetcherNiddle();

  @override
  Duration? get cacheDuration => const Duration(days: 30);

  @override
  Future<LocalizedEvents> loadFromStorage() async {
    final ptEvents = await jsonFetcher.getCalendar('pt');
    final enEvents = await jsonFetcher.getCalendar('en');

    return LocalizedEvents(
      events: {AppLocale.pt: ptEvents, AppLocale.en: enEvents},
    );
  }

  @override
  Future<LocalizedEvents> loadFromRemote() async {
    final profile = ref.read(profileProvider).asData?.value;
    final session = ref.read(sessionProvider).asData?.value;

    if (profile == null || session == null || profile.courses.isEmpty) {
      return state.value ?? LocalizedEvents(events: {});
    }

    final year = _getAcademicYear(DateTime.now());
    final course = profile.courses.first;
    final facultyId = EventsFetcherConstants.facultyIds[course.faculty];

    if (facultyId == null || course.id == null) {
      throw Exception('Unable to determine faculty or course ID');
    }

    final events = await niddleFetcher.fetchEvents(
      year: year,
      facultyId: facultyId,
      courseId: course.id!,
    );

    return LocalizedEvents(
      events: {AppLocale.pt: events, AppLocale.en: events},
    );
  }

  int _getAcademicYear(DateTime date) => date.month < 9 ? date.year - 1 : date.year;
}
