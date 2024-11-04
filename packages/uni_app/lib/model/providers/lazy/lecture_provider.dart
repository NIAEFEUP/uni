import 'dart:async';

import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_new_api.dart';
import 'package:uni/controller/local_storage/database/app_lectures_database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/session/flows/base/session.dart';

class LectureProvider extends StateProviderNotifier<List<Lecture>> {
  LectureProvider() : super(cacheDuration: const Duration(hours: 6));

  @override
  Future<List<Lecture>> loadFromStorage(StateProviders stateProviders) async {
    final db = AppLecturesDatabase();
    return db.lectures();
  }

  @override
  Future<List<Lecture>> loadFromRemote(StateProviders stateProviders) async {
    return fetchUserLectures(
      stateProviders.sessionProvider.state!,
    );
  }

  Future<List<Lecture>> fetchUserLectures(
    Session session, {
    ScheduleFetcher? fetcher,
  }) async {
    final lectures = await getLecturesFromFetcherOrElse(fetcher, session);

    final db = AppLecturesDatabase();
    await db.saveIfPersistentSession(lectures);

    return lectures;
  }

  Future<List<Lecture>> getLecturesFromFetcherOrElse(
    ScheduleFetcher? fetcher,
    Session session,
  ) =>
      fetcher?.getLectures(session) ?? getLectures(session);

  Future<List<Lecture>> getLectures(Session session) {
    return ScheduleFetcherNewApi().getLectures(session).catchError(
          (e) => <Lecture>[],
        );
  }
}
