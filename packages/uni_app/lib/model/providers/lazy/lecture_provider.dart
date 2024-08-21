import 'dart:async';

import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_api.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_html.dart';
import 'package:uni/controller/local_storage/database/app_lectures_database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/session/base/session.dart';

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
      stateProviders.profileProvider.state!,
    );
  }

  Future<List<Lecture>> fetchUserLectures(
    Session session,
    Profile profile, {
    ScheduleFetcher? fetcher,
  }) async {
    final lectures =
        await getLecturesFromFetcherOrElse(fetcher, session, profile);

    final db = AppLecturesDatabase();
    await db.saveIfPersistentSession(lectures);

    return lectures;
  }

  Future<List<Lecture>> getLecturesFromFetcherOrElse(
    ScheduleFetcher? fetcher,
    Session session,
    Profile profile,
  ) =>
      fetcher?.getLectures(session, profile) ?? getLectures(session, profile);

  Future<List<Lecture>> getLectures(Session session, Profile profile) {
    return ScheduleFetcherApi()
        .getLectures(session, profile)
        .catchError((e) => ScheduleFetcherHtml().getLectures(session, profile));
  }
}
