import 'dart:async';
import 'dart:collection';

import 'package:tuple/tuple.dart';
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
  List<Lecture> _lectures = [];

  LectureProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(hours: 6));

  UnmodifiableListView<Lecture> get lectures => UnmodifiableListView(_lectures);

  @override
  Future<void> loadFromStorage() async {
    final AppLecturesDatabase db = AppLecturesDatabase();
    final List<Lecture> lectures = await db.lectures();
    _lectures = lectures;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchUserLectures(
        await AppSharedPreferences.getPersistentUserInfo(), session, profile);
  }

  Future<void> fetchUserLectures(Tuple2<String, String> userPersistentInfo,
      Session session, Profile profile,
      {ScheduleFetcher? fetcher}) async {
    try {
      final List<Lecture> lectures =
      await getLecturesFromFetcherOrElse(fetcher, session, profile);

      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppLecturesDatabase db = AppLecturesDatabase();
        db.saveNewLectures(lectures);
      }

      _lectures = lectures;
      updateStatus(RequestStatus.successful);
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }

  Future<List<Lecture>> getLecturesFromFetcherOrElse(ScheduleFetcher? fetcher,
      Session session, Profile profile) =>
      (fetcher?.getLectures(session, profile)) ?? getLectures(session, profile);

  Future<List<Lecture>> getLectures(Session session, Profile profile) {
    return ScheduleFetcherApi()
        .getLectures(session, profile)
        .catchError((e) => ScheduleFetcherHtml().getLectures(session, profile));
  }
}
