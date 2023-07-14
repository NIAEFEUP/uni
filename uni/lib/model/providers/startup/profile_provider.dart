import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/all_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/current_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/controller/fetchers/profile_fetcher.dart';
import 'package:uni/controller/local_storage/app_course_units_database.dart';
import 'package:uni/controller/local_storage/app_courses_database.dart';
import 'package:uni/controller/local_storage/app_refresh_times_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/app_user_database.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/controller/parsers/parser_print_balance.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class ProfileProvider extends StateProviderNotifier {
  Profile _profile = Profile();
  DateTime? _feesRefreshTime;
  DateTime? _printRefreshTime;

  ProfileProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(days: 1));

  String get feesRefreshTime => _feesRefreshTime.toString();

  String get printRefreshTime => _printRefreshTime.toString();

  Profile get profile => _profile;

  @override
  Future<void> loadFromStorage() async {
    await loadProfile();
    await Future.wait(
        [loadCourses(), loadBalanceRefreshTimes(), loadCourseUnits()]);
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    final userInfoAction = Completer<void>();
    fetchUserInfo(userInfoAction, session);
    await userInfoAction.future;

    final Completer<void> userFeesAction = Completer<void>();
    fetchUserFees(userFeesAction, session);

    final Completer<void> printBalanceAction = Completer<void>();
    fetchUserPrintBalance(printBalanceAction, session);

    final Completer<void> courseUnitsAction = Completer<void>();
    fetchCourseUnitsAndCourseAverages(session, courseUnitsAction);

    await Future.wait([
      userFeesAction.future,
      printBalanceAction.future,
      courseUnitsAction.future
    ]);

    if (status != RequestStatus.failed) {
      updateStatus(RequestStatus.successful);
    }
  }

  Future<void> loadProfile() async {
    final profileDb = AppUserDataDatabase();
    _profile = await profileDb.getUserData();
  }

  Future<void> loadCourses() async {
    final AppCoursesDatabase coursesDb = AppCoursesDatabase();
    final List<Course> courses = await coursesDb.courses();
    _profile.courses = courses;
  }

  Future<void> loadBalanceRefreshTimes() async {
    final AppRefreshTimesDatabase refreshTimesDb = AppRefreshTimesDatabase();
    final Map<String, String> refreshTimes =
    await refreshTimesDb.refreshTimes();

    final printRefreshTime = refreshTimes['print'];
    final feesRefreshTime = refreshTimes['fees'];
    if (printRefreshTime != null) {
      _printRefreshTime = DateTime.parse(printRefreshTime);
    }
    if (feesRefreshTime != null) {
      _feesRefreshTime = DateTime.parse(feesRefreshTime);
    }
  }

  Future<void> loadCourseUnits() async {
    final AppCourseUnitsDatabase db = AppCourseUnitsDatabase();
    profile.courseUnits = await db.courseUnits();
  }

  fetchUserFees(Completer<void> action, Session session) async {
    try {
      final response = await FeesFetcher().getUserFeesResponse(session);

      final String feesBalance = await parseFeesBalance(response);
      final DateTime? feesLimit = await parseFeesNextLimit(response);

      final DateTime currentTime = DateTime.now();
      final Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        await storeRefreshTime('fees', currentTime.toString());

        // Store fees info
        final profileDb = AppUserDataDatabase();
        profileDb.saveUserFees(feesBalance, feesLimit);
      }

      final Profile newProfile = Profile(
          name: _profile.name,
          email: _profile.email,
          courses: _profile.courses,
          printBalance: _profile.printBalance,
          feesBalance: feesBalance,
          feesLimit: feesLimit);

      _profile = newProfile;
      _feesRefreshTime = currentTime;
      notifyListeners();
    } catch (e) {
      Logger().e('Failed to get Fees info');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  Future storeRefreshTime(String db, String currentTime) async {
    final AppRefreshTimesDatabase refreshTimesDatabase =
    AppRefreshTimesDatabase();
    refreshTimesDatabase.saveRefreshTime(db, currentTime);
  }

  fetchUserPrintBalance(Completer<void> action, Session session) async {
    try {
      final response = await PrintFetcher().getUserPrintsResponse(session);
      final String printBalance = await getPrintsBalance(response);

      final DateTime currentTime = DateTime.now();
      final Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        await storeRefreshTime('print', currentTime.toString());

        // Store fees info
        final profileDb = AppUserDataDatabase();
        profileDb.saveUserPrintBalance(printBalance);
      }

      final Profile newProfile = Profile(
          name: _profile.name,
          email: _profile.email,
          courses: _profile.courses,
          printBalance: printBalance,
          feesBalance: _profile.feesBalance,
          feesLimit: _profile.feesLimit);

      _profile = newProfile;
      _printRefreshTime = currentTime;
      notifyListeners();
    } catch (e) {
      Logger().e('Failed to get Print Balance');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  fetchUserInfo(Completer<void> action, Session session) async {
    try {
      updateStatus(RequestStatus.busy);

      final profile = await ProfileFetcher.getProfile(session);
      final currentCourseUnits =
      await CurrentCourseUnitsFetcher().getCurrentCourseUnits(session);

      _profile = profile;
      _profile.courseUnits = currentCourseUnits;

      updateStatus(RequestStatus.successful);

      final Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final profileDb = AppUserDataDatabase();
        profileDb.insertUserData(_profile);
      }
    } catch (e) {
      Logger().e('Failed to get User Info');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  fetchCourseUnitsAndCourseAverages(Session session,
      Completer<void> action) async {
    updateStatus(RequestStatus.busy);
    try {
      final List<Course> courses = profile.courses;
      final List<CourseUnit> allCourseUnits = await AllCourseUnitsFetcher()
          .getAllCourseUnitsAndCourseAverages(profile.courses, session);

      _profile.courseUnits = allCourseUnits;

      final Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppCoursesDatabase coursesDb = AppCoursesDatabase();
        await coursesDb.saveNewCourses(courses);

        final courseUnitsDatabase = AppCourseUnitsDatabase();
        await courseUnitsDatabase.saveNewCourseUnits(_profile.courseUnits);
      }
    } catch (e) {
      Logger().e('Failed to get all user ucs: $e');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  static Future<File?> fetchOrGetCachedProfilePicture(Session session,
      {forceRetrieval = false}) {
    final String studentNumber = session.studentNumber;
    final String faculty = session.faculties[0];
    final String url =
        'https://sigarra.up.pt/$faculty/pt/fotografias_service.foto?pct_cod=$studentNumber';
    final Map<String, String> headers = <String, String>{};
    headers['cookie'] = session.cookies;
    return loadFileFromStorageOrRetrieveNew(
        'user_profile_picture', url, headers,
        forceRetrieval: forceRetrieval);
  }
}
