import 'dart:async';
import 'dart:collection';

import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_api.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_html.dart';
import 'package:uni/controller/local_storage/app_lectures_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class LectureProvider extends StateProviderNotifier {
  LectureProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 6));
  List<Lecture> _lectures = [];

  UnmodifiableListView<Lecture> get lectures => UnmodifiableListView(_lectures);

  @override
  Future<void> loadFromStorage() async {
    final db = AppLecturesDatabase();
    final lectures = await db.lectures();
    _lectures = lectures;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchUserLectures(
      session,
      profile,
      persistentSession:
          (await AppSharedPreferences.getPersistentUserInfo()) != null,
    );
  }

  Future<void> fetchUserLectures(
    Session session,
    Profile profile, {
    required bool persistentSession,
    ScheduleFetcher? fetcher,
  }) async {
    try {
      final lectures =
          await getLecturesFromFetcherOrElse(fetcher, session, profile);

      if (persistentSession) {
        final db = AppLecturesDatabase();
        await db.saveNewLectures(lectures);
      }

      _lectures = lectures;
      updateStatus(RequestStatus.successful);
    } catch (e, stacktrace) {
      updateStatus(RequestStatus.failed);
    }
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
