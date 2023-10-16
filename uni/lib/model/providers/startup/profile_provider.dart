import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/fetchers/courses_fetcher/all_course_units_fetcher_api.dart';
import 'package:uni/controller/fetchers/courses_fetcher/all_course_units_fetcher_html.dart';
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
        super(dependsOnSession: true, cacheDuration: null);
  Profile _profile;

  Profile get profile => _profile;

  @override
  Future<void> loadFromStorage() async {
    await loadProfile();
    await loadCourses();
    await loadCourseUnits();
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchUserInfo(session);

    await Future.wait([
      fetchFees(session),
      // fetchUserPrintBalance(session), // FIXME: bring back when it's fixed
      fetchCourses(session)
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
    if (profile.courses.isEmpty) {
      return;
    }

    final db = AppCourseUnitsDatabase();

    // FIXME (bdmendes): This is assuming that the saved course units are from
    // the first course. This is due to the db schema not saving the relation
    // between course and course units.
    // It currently has no effect, since we are not relating course units
    // to courses, but it should be fixed for future UI improvements.
    profile.courses[0].courseUnits = await db.courseUnits();
  }

  Future<void> fetchFees(Session session) async {
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

    _profile = profile ?? Profile();

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    if (userPersistentInfo != null) {
      final profileDb = AppUserDataDatabase();
      await profileDb.insertUserData(_profile);
    }
  }

  Future<void> fetchCourses(Session session) async {
    final courses = profile.courses;

    final allCourses = await AllCourseUnitsFetcherApi()
        .getCourses(
      session,
    )
        .catchError((dynamic e) {
      Sentry.captureException(e);
      return AllCourseUnitsFetcherHtml().getCourses(
        session,
      );
    });

    _profile.courses = allCourses;

    final userPersistentInfo =
        await AppSharedPreferences.getPersistentUserInfo();
    if (userPersistentInfo != null) {
      final coursesDb = AppCoursesDatabase();
      await coursesDb.saveNewCourses(courses);

      final courseUnitsDatabase = AppCourseUnitsDatabase();
      await courseUnitsDatabase.saveNewCourseUnits(
        _profile.courses.map((e) => e.courseUnits).flattened.toList(),
      );
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
