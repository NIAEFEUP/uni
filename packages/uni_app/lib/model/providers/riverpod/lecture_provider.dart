import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_new_api.dart';
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
    return Database().lectures;
  }

  @override
  Future<List<Lecture>?> loadFromRemote() async {
    final session = await ref.read(sessionProvider.future);

    if (session == null) {
      return null;
    }

    try {
      //try to fetch from the internet
      final lectures = await _getLectures(session);

      //if success save to database (overwrite old cache)
      Database().saveLectures(lectures);

      return lectures;
    } catch (e) {
      //if failure check if we have cached lectures
      final cachedLectures = Database().lectures;

      if (cachedLectures.isNotEmpty) {
        return cachedLectures;
      }

      //if no internet and no cache -> show error
      rethrow;
    }
  }

  Future<List<Lecture>> _getLectures(Session session) {
    //removed the .catchError so it throws properly when offline
    return ScheduleFetcherNewApi().getLectures(session);
  }
}
