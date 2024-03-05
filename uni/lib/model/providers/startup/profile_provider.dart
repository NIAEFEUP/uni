import 'dart:async';
import 'dart:io';

import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/all_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/current_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/controller/fetchers/profile_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_course_units_database.dart';
import 'package:uni/controller/local_storage/database/app_courses_database.dart';
import 'package:uni/controller/local_storage/database/app_user_database.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/controller/parsers/parser_print_balance.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class ProfileProvider extends StateProviderNotifier<Profile> {
  ProfileProvider()
      : super(cacheDuration: const Duration(days: 1), dependsOnSession: false);

  @override
  Future<Profile> loadFromStorage(StateProviders stateProviders) async {
    final databaseFutures = await Future.wait([
      loadProfile(),
      loadCourses(),
      loadCourseUnits(),
    ]);

    final profile = databaseFutures[0] as Profile;
    final courses = databaseFutures[1] as List<Course>;
    final courseUnits = databaseFutures[2] as List<CourseUnit>;

    profile
      ..courses = courses
      ..courseUnits = courseUnits;

    return profile;
  }

  @override
  Future<Profile> loadFromRemote(StateProviders stateProviders) async {
    final session = stateProviders.sessionProvider.state!;

    final profileFuture = fetchUserInfo(session);
    final courseUnitsFutures = profileFuture.then(
      (profile) => fetchCourseUnitsAndCourseAverages(session, profile!),
    );

    final futures = await Future.wait([
      profileFuture,
      courseUnitsFutures,
      fetchUserFeesBalanceAndLimit(session),
      fetchUserPrintBalance(session),
    ]);
    final profile = futures[0] as Profile?;
    final courseUnits = futures[1] as List<CourseUnit>?;
    final userBalanceAndFeesLimit = futures[2]! as Tuple2<String, DateTime?>;
    final printBalance = futures[3]! as String;

    profile!
      ..feesBalance = userBalanceAndFeesLimit.item1
      ..feesLimit = userBalanceAndFeesLimit.item2
      ..printBalance = printBalance;

    if (courseUnits != null) {
      profile.courseUnits = courseUnits;
    }

    return profile;
  }

  Future<Profile> loadProfile() {
    final profileDb = AppUserDataDatabase();
    return profileDb.getUserData();
  }

  Future<List<Course>> loadCourses() {
    final coursesDb = AppCoursesDatabase();
    return coursesDb.courses();
  }

  Future<List<CourseUnit>> loadCourseUnits() {
    final db = AppCourseUnitsDatabase();
    return db.courseUnits();
  }

  Future<Tuple2<String, DateTime?>> fetchUserFeesBalanceAndLimit(
    Session session,
  ) async {
    final response = await FeesFetcher().getUserFeesResponse(session);

    final feesBalance = parseFeesBalance(response);
    final feesLimit = parseFeesNextLimit(response);

    final userPersistentInfo =
        await PreferencesController.getPersistentUserInfo();

    if (userPersistentInfo != null) {
      final profileDb = AppUserDataDatabase();
      await profileDb.saveUserFees(feesBalance, feesLimit);
    }

    return Tuple2(feesBalance, feesLimit);
  }

  Future<String> fetchUserPrintBalance(Session session) async {
    final response = await PrintFetcher().getUserPrintsResponse(session);
    final printBalance = await getPrintsBalance(response);

    final userPersistentInfo =
        await PreferencesController.getPersistentUserInfo();
    if (userPersistentInfo != null) {
      final profileDb = AppUserDataDatabase();
      await profileDb.saveUserPrintBalance(printBalance);
    }

    return printBalance;
  }

  Future<Profile?> fetchUserInfo(Session session) async {
    final profile = await ProfileFetcher.fetchProfile(session);
    if (profile == null) {
      return null;
    }

    final currentCourseUnits =
        await CurrentCourseUnitsFetcher().getCurrentCourseUnits(session);

    profile.courseUnits = currentCourseUnits;

    final userPersistentInfo =
        await PreferencesController.getPersistentUserInfo();
    if (userPersistentInfo != null) {
      // Course units are saved later, so we don't it here
      final profileDb = AppUserDataDatabase();
      await profileDb.insertUserData(profile);
    }

    return profile;
  }

  Future<List<CourseUnit>?> fetchCourseUnitsAndCourseAverages(
    Session session,
    Profile profile,
  ) async {
    final allCourseUnits =
        await AllCourseUnitsFetcher().getAllCourseUnitsAndCourseAverages(
      profile.courses,
      session,
      currentCourseUnits: profile.courseUnits,
    );

    if (allCourseUnits == null) {
      return allCourseUnits;
    }

    final userPersistentInfo =
        await PreferencesController.getPersistentUserInfo();
    if (userPersistentInfo != null) {
      final coursesDb = AppCoursesDatabase();
      unawaited(coursesDb.saveNewCourses(profile.courses));

      final courseUnitsDatabase = AppCourseUnitsDatabase();
      unawaited(courseUnitsDatabase.saveNewCourseUnits(allCourseUnits));
    }

    return allCourseUnits;
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
