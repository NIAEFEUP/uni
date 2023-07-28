import 'dart:async';
import 'dart:io';

import 'package:uni/controller/fetchers/course_units_fetcher/all_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/current_course_units_fetcher.dart';
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
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class ProfileProvider extends StateProviderNotifier {
  ProfileProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(days: 1));
  Profile _profile = Profile();
  DateTime? _feesRefreshTime;
  DateTime? _printRefreshTime;

  String get feesRefreshTime => _feesRefreshTime.toString();

  String get printRefreshTime => _printRefreshTime.toString();

  Profile get profile => _profile;

  @override
  Future<void> loadFromStorage() async {
    await loadProfile();
    await Future.wait(
      [loadCourses(), loadBalanceRefreshTimes(), loadCourseUnits()],
    );
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchUserInfo(session);

    await Future.wait([
      fetchUserFees(session),
      fetchUserPrintBalance(session),
      fetchCourseUnitsAndCourseAverages(session)
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
    final coursesDb = AppCoursesDatabase();
    final courses = await coursesDb.courses();
    _profile.courses = courses;
  }

  Future<void> loadBalanceRefreshTimes() async {
    final refreshTimesDb = AppRefreshTimesDatabase();
    final refreshTimes = await refreshTimesDb.refreshTimes();

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
    final db = AppCourseUnitsDatabase();
    profile.courseUnits = await db.courseUnits();
  }

  Future<void> fetchUserFees(Session session) async {
    try {
      final response = await FeesFetcher().getUserFeesResponse(session);

      final feesBalance = await parseFeesBalance(response);
      final feesLimit = await parseFeesNextLimit(response);

      final currentTime = DateTime.now();
      final userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {}
      final newProfile = Profile(
        name: _profile.name,
        email: _profile.email,
        courses: _profile.courses,
        printBalance: _profile.printBalance,
        feesBalance: feesBalance,
        feesLimit: feesLimit,
      );

      _profile = newProfile;
      _feesRefreshTime = currentTime;
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }

  Future<void> storeRefreshTime(String db, String currentTime) async {
    final refreshTimesDatabase = AppRefreshTimesDatabase();
    await refreshTimesDatabase.saveRefreshTime(db, currentTime);
  }

  Future<void> fetchUserPrintBalance(Session session) async {
    try {
      final response = await PrintFetcher().getUserPrintsResponse(session);
      final printBalance = await getPrintsBalance(response);

      final currentTime = DateTime.now();
      final userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        await storeRefreshTime('print', currentTime.toString());
        final profileDb = AppUserDataDatabase();
        await profileDb.saveUserPrintBalance(printBalance);
      }

      final newProfile = Profile(
        name: _profile.name,
        email: _profile.email,
        courses: _profile.courses,
        printBalance: printBalance,
        feesBalance: _profile.feesBalance,
        feesLimit: _profile.feesLimit,
      );

      _profile = newProfile;
      _printRefreshTime = currentTime;
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }

  Future<void> fetchUserInfo(Session session) async {
    try {
      final profile = await ProfileFetcher.getProfile(session);
      final currentCourseUnits =
          await CurrentCourseUnitsFetcher().getCurrentCourseUnits(session);

      _profile = profile;
      _profile.courseUnits = currentCourseUnits;

      updateStatus(RequestStatus.successful);

      final userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final profileDb = AppUserDataDatabase();
        await profileDb.insertUserData(_profile);
      }
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }

  Future<void> fetchCourseUnitsAndCourseAverages(Session session) async {
    try {
      final courses = profile.courses;
      final allCourseUnits = await AllCourseUnitsFetcher()
          .getAllCourseUnitsAndCourseAverages(profile.courses, session);

      _profile.courseUnits = allCourseUnits;

      final userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final coursesDb = AppCoursesDatabase();
        await coursesDb.saveNewCourses(courses);

        final courseUnitsDatabase = AppCourseUnitsDatabase();
        await courseUnitsDatabase.saveNewCourseUnits(_profile.courseUnits);
      }
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }

  static Future<File?> fetchOrGetCachedProfilePicture(
    Session session, {
    bool forceRetrieval = false,
    int? studentNumber,
  }) {
    studentNumber ??= int.parse(session.username.replaceAll('up', ''));

    final faculty = session.faculties[0];
    final url =
        'https://sigarra.up.pt/$faculty/pt/fotografias_service.foto?pct_cod=$studentNumber';
    final headers = <String, String>{};
    headers['cookie'] = session.cookies;
    return loadFileFromStorageOrRetrieveNew(
      '${studentNumber}_profile_picture',
      url,
      headers,
      forceRetrieval: forceRetrieval,
    );
  }
}
