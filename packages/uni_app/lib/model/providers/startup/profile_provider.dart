import 'dart:async';
import 'dart:io';

import 'package:uni/controller/fetchers/course_units_fetcher/all_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/current_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/controller/fetchers/profile_fetcher.dart';
import 'package:uni/controller/local_storage/database-nosql/course_units_database.dart';
import 'package:uni/controller/local_storage/database-nosql/courses_database.dart';
import 'package:uni/controller/local_storage/database-nosql/database.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/controller/parsers/parser_print_balance.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/session/flows/base/session.dart';

class ProfileProvider extends StateProviderNotifier<Profile> {
  ProfileProvider()
      : super(cacheDuration: const Duration(days: 1), dependsOnSession: false);

  @override
  Future<Profile> loadFromStorage(StateProviders stateProviders) async {
    final databaseFutures = await Future.wait([
      loadCourses(),
      loadCourseUnits(),
    ]);

    final profile = Database().getProfile();
    final courses = databaseFutures[0] as List<Course>;
    final courseUnits = databaseFutures[1] as List<CourseUnit>;

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
    final userBalanceAndFeesLimit = futures[2]! as (String, DateTime?);
    final printBalance = futures[3]! as String;

    profile!
      ..feesBalance = userBalanceAndFeesLimit.$1
      ..feesLimit = userBalanceAndFeesLimit.$2
      ..printBalance = printBalance;

    if (courseUnits != null) {
      profile.courseUnits = courseUnits;
    }

    Database().saveProfile(profile);

    return profile;
  }

  Future<List<Course>> loadCourses() {
    final coursesDb = CoursesDatabase();
    return coursesDb.getAll();
  }

  Future<List<CourseUnit>> loadCourseUnits() {
    final db = CourseUnitsDatabase();
    return db.getAll();
  }

  Future<(String, DateTime?)> fetchUserFeesBalanceAndLimit(
    Session session,
  ) async {
    final response = await FeesFetcher().getUserFeesResponse(session);

    final feesBalance = parseFeesBalance(response);
    final feesLimit = parseFeesNextLimit(response);

    return (feesBalance, feesLimit);
  }

  Future<String> fetchUserPrintBalance(Session session) async {
    final response = await PrintFetcher().getUserPrintsResponse(session);
    final printBalance = await getPrintsBalance(response);

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

    final coursesDb = CoursesDatabase();
    unawaited(coursesDb.saveIfPersistentSession(profile.courses));

    final courseUnitsDatabase = CourseUnitsDatabase();
    unawaited(courseUnitsDatabase.saveIfPersistentSession(allCourseUnits));

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
