import 'dart:async';
import 'dart:io';

import 'package:uni/controller/fetchers/course_units_fetcher/all_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/current_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/controller/fetchers/profile_fetcher.dart';
import 'package:uni/controller/local_storage/app_course_units_database.dart';
import 'package:uni/controller/local_storage/app_courses_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/app_user_database.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/controller/parsers/parser_print_balance.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class ProfileProvider extends StateProviderNotifier {
  ProfileProvider()
      : _profile = Profile(),
        super(dependsOnSession: true, cacheDuration: const Duration(days: 1));
  Profile _profile;

  Profile get profile => _profile;

  @override
  Future<void> loadFromStorage() async {
    await loadProfile();
    await Future.wait(
      [loadCourses(), loadCourseUnits()],
    );
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchUserInfo(session);

    await Future.wait([
      fetchUserFees(session),
      fetchUserPrintBalance(session),
      fetchCourseUnitsAndCourseAverages(session),
    ]);
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

  Future<void> loadCourseUnits() async {
    final db = AppCourseUnitsDatabase();
    profile.courseUnits = await db.courseUnits();
  }

  Future<void> fetchUserFees(Session session) async {
    final response = await FeesFetcher().getUserFeesResponse(session);

    final feesBalance = parseFeesBalance(response);
    final feesLimit = parseFeesNextLimit(response);

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();

    if (userPersistentInfo != null) {
      final profileDb = AppUserDataDatabase();
      await profileDb.saveUserFees(feesBalance, feesLimit);
    }

    _profile
      ..feesBalance = feesBalance
      ..feesLimit = feesLimit;
  }

  Future<void> fetchUserPrintBalance(Session session) async {
    final response = await PrintFetcher().getUserPrintsResponse(session);
    final printBalance = await getPrintsBalance(response);

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    if (userPersistentInfo != null) {
      final profileDb = AppUserDataDatabase();
      await profileDb.saveUserPrintBalance(printBalance);
    }

    _profile.printBalance = printBalance;
  }

  Future<void> fetchUserInfo(Session session) async {
    final profile = await ProfileFetcher.fetchProfile(session);
    final currentCourseUnits =
        await CurrentCourseUnitsFetcher().getCurrentCourseUnits(session);

    _profile = profile ?? Profile();
    _profile.courseUnits = currentCourseUnits;

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    if (userPersistentInfo != null) {
      // Course units are saved later, so we don't it here
      final profileDb = AppUserDataDatabase();
      await profileDb.insertUserData(_profile);
    }
  }

  Future<void> fetchCourseUnitsAndCourseAverages(Session session) async {
    final courses = profile.courses;
    final allCourseUnits =
        await AllCourseUnitsFetcher().getAllCourseUnitsAndCourseAverages(
      profile.courses,
      session,
      currentCourseUnits: profile.courseUnits,
    );

    if (allCourseUnits != null) {
      _profile.courseUnits = allCourseUnits;
    } else {
      // Current course units should already have been fetched,
      // so this is not a fatal error
    }

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    if (userPersistentInfo != null) {
      final coursesDb = AppCoursesDatabase();
      await coursesDb.saveNewCourses(courses);

      final courseUnitsDatabase = AppCourseUnitsDatabase();
      await courseUnitsDatabase.saveNewCourseUnits(_profile.courseUnits);
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

    return loadFileFromStorageOrRetrieveNew(
      '${studentNumber}_profile_picture',
      url,
      session,
      forceRetrieval: forceRetrieval,
    );
  }
}
