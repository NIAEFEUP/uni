import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/academics/schedule/schedule_fetcher_new_api.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/model/services/widget_service.dart';
import 'package:uni/session/flows/base/session.dart';

final lectureProvider = AsyncNotifierProvider<LectureNotifier, List<Lecture>?>(
  LectureNotifier.new,
);

class LectureNotifier extends CachedAsyncNotifier<List<Lecture>> {
  void _updateWidgetWithNextLectures(List<Lecture> allLectures) {
    final now = DateTime.now();

    final upcomingLectures = allLectures.where((lecture) {
      return lecture.endTime.isAfter(now);
    }).toList();

    final lecturesForWidget = upcomingLectures.take(20).toList();

    unawaited(
      WidgetService.updateScheduleWidget(
        lecturesForWidget.map((l) => l.toJson()).toList(),
      ),
    );
  }

  @override
  Duration? get cacheDuration => const Duration(hours: 6);

  @override
  void onStateChanged(List<Lecture>? newState) {
    if (newState != null) {
      _updateWidgetWithNextLectures(newState);
    }
  }

  @override
  Future<List<Lecture>> loadFromStorage() async {
    final lectures = Database().lectures.toSet().toList();

    // update widget when app starts and loads cached local data
    _updateWidgetWithNextLectures(lectures);

    return lectures;
  }

  @override
  Future<List<Lecture>?> loadFromRemote() async {
    final session = await ref.read(sessionProvider.future);

    if (session == null) {
      return null;
    }

    final lectures = (await _getLectures(session)).toSet().toList();

    try {
      await Database().saveLectures(lectures);

      // update widget when new data is downloaded in the bg or pulled manually
      _updateWidgetWithNextLectures(lectures);
    } catch (err, st) {
      Logger().e(
        'Failed to save lectures to local database',
        error: err,
        stackTrace: st,
      );
    }

    return lectures;
  }

  // FIXME: delete fallback fetcher code.
  Future<List<Lecture>> _getLectures(Session session) {
    return ScheduleFetcherNewApi().getLectures(session);
  }
}
