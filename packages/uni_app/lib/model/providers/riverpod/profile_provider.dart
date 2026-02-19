import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/all_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/current_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/controller/fetchers/profile_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/controller/local_storage/file_offline_storage.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/controller/parsers/parser_print_balance.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/pedagogical_surveys_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/session/flows/base/session.dart';

final profileProvider = AsyncNotifierProvider<ProfileNotifier, Profile?>(
  ProfileNotifier.new,
);

class ProfileNotifier extends CachedAsyncNotifier<Profile?> {
  @override
  Duration? get cacheDuration => const Duration(days: 1);

  @override
  Future<Profile?> loadFromStorage() async {
    final profile = Database().profile
      ?..courses = Database().courses
      ..courseUnits = Database().courseUnits;

    return profile;
  }

  @override
  Future<Profile?> loadFromRemote() async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return null;
    }

    //try to fetch all data from internet
    final profile = await _fetchUserInfo(session);
    if (profile == null) {
      return null;
    }

    final courseUnits = await _fetchCourseUnitsAndAverages(session, profile);
    final (feesBalance, feesLimit) = await _fetchFees(session);
    final printBalance = await _fetchPrintBalance(session);

    profile
      ..courseUnits = courseUnits ?? []
      ..feesBalance = feesBalance
      ..feesLimit = feesLimit
      ..printBalance = printBalance;

    if (profile.answeredPedagogicalSurveys) {
      await PreferencesController.setPedagogicalSurveysShowDialog(show: false);
      await PreferencesController.setPedagogicalSurveysDismissed(
        dismissed: false,
      );
    } else {
      await PreferencesController.setPedagogicalSurveysShowDialog(show: true);
    }

    ref.read(pedagogicalSurveysProvider.notifier).state =
        PreferencesController.shouldShowPedagogicalSurveysDialog();

    // if successful save everything to cache
    Database().saveProfile(profile);

    return profile;
  }

  Future<Profile?> _fetchUserInfo(Session session) async {
    final profile = await ProfileFetcher.fetchProfile(session);
    if (profile == null) {
      return null;
    }

    final currentCourseUnits = await CurrentCourseUnitsFetcher()
        .getCurrentCourseUnits(session);

    profile.courseUnits = currentCourseUnits;

    return profile;
  }

  Future<List<CourseUnit>?> _fetchCourseUnitsAndAverages(
    Session session,
    Profile profile,
  ) async {
    final allCourseUnits = await AllCourseUnitsFetcher()
        .getAllCourseUnitsAndCourseAverages(
          profile.courses,
          session,
          currentCourseUnits: profile.courseUnits,
        );

    if (allCourseUnits != null) {
      Database().saveCourses(profile.courses);
      Database().saveCourseUnits(allCourseUnits);
    }

    return allCourseUnits;
  }

  Future<(String, DateTime?)> _fetchFees(Session session) async {
    final response = await FeesFetcher().getUserFeesResponse(session);
    return (parseFeesBalance(response), parseFeesNextLimit(response));
  }

  Future<String> _fetchPrintBalance(Session session) async {
    final response = await PrintFetcher().getUserPrintsResponse(session);
    final printBalance = await getPrintsBalance(response);

    return printBalance;
  }

  static Future<File?> fetchOrGetCachedProfilePicture(
    Session session, {
    bool forceRetrieval = false,
    int? studentNumber,
  }) {
    studentNumber ??= int.parse(session.username.replaceAll('up', ''));
    final faculty = session.faculties.first;
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
