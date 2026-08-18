import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/academics/schedule/schedule_fetcher_new_api.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';

final lectureProvider = AsyncNotifierProvider<LectureNotifier, List<Lecture>?>(
  LectureNotifier.new,
);

class LectureNotifier extends CachedAsyncNotifier<List<Lecture>> {
  @override
  Duration? get cacheDuration => const Duration(hours: 6);

  @override
  Future<List<Lecture>> loadFromStorage() async {
    return Database().lectures.toSet().toList();
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
