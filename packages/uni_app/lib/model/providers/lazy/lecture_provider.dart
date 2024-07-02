import 'dart:async';

import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_api.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_html.dart';
import 'package:uni/controller/local_storage/database/app_lectures_database.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

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
      persistentSession:
          (await PreferencesController.getPersistentUserInfo()) != null,
    );
  }

  Future<List<Lecture>> fetchUserLectures(
    Session session,
    Profile profile, {
    required bool persistentSession,
    ScheduleFetcher? fetcher,
  }) async {
    final lectures =
        await getLecturesFromFetcherOrElse(fetcher, session, profile);

    if (persistentSession) {
      final db = AppLecturesDatabase();
      await db.saveNewLectures(lectures);
    }

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
