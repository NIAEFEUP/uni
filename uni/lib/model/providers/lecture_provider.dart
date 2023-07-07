import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
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

  UnmodifiableListView<Lecture> get lectures => UnmodifiableListView(_lectures);

  @override
  void loadFromStorage() async {
    final AppLecturesDatabase db = AppLecturesDatabase();
    final List<Lecture> lectures = await db.lectures();
    _lectures = lectures;
    notifyListeners();
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    final Completer<void> action = Completer<void>();
    fetchUserLectures(action, userPersistentInfo, session, profile);
    await action.future;
  }

  void fetchUserLectures(
      Completer<void> action,
      Tuple2<String, String> userPersistentInfo,
      Session session,
      Profile profile,
      {ScheduleFetcher? fetcher}) async {
    try {
      updateStatus(RequestStatus.busy);

      final List<Lecture> lectures =
          await getLecturesFromFetcherOrElse(fetcher, session, profile);

      // Updates local database according to the information fetched -- Lectures
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppLecturesDatabase db = AppLecturesDatabase();
        db.saveNewLectures(lectures);
      }

      _lectures = lectures;
      notifyListeners();
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get Schedule: ${e.toString()}');
      updateStatus(RequestStatus.failed);
    }
    action.complete();
  }

  Future<List<Lecture>> getLecturesFromFetcherOrElse(
          ScheduleFetcher? fetcher, Session session, Profile profile) =>
      (fetcher?.getLectures(session, profile)) ?? getLectures(session, profile);

  Future<List<Lecture>> getLectures(Session session, Profile profile) {
    return ScheduleFetcherApi()
        .getLectures(session, profile)
        .catchError((e) => ScheduleFetcherHtml().getLectures(session, profile));
  }
}
