import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/current_course_units_fetcher.dart';
import 'package:uni/controller/fetchers/fees_fetcher.dart';
import 'package:uni/controller/fetchers/print_fetcher.dart';
import 'package:uni/controller/fetchers/profile_fetcher.dart';
import 'package:uni/controller/local_storage/app_course_units_database.dart';
import 'package:uni/controller/local_storage/app_courses_database.dart';
import 'package:uni/controller/local_storage/app_refresh_times_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/app_user_database.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/controller/parsers/parser_print_balance.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

// ignore: always_use_package_imports
import '../../controller/fetchers/all_course_units_fetcher.dart';

class ProfileStateProvider extends StateProviderNotifier {
  List<CourseUnit> _currUcs = [];
  Profile _profile = Profile();
  DateTime? _feesRefreshTime;
  DateTime? _printRefreshTime;

  UnmodifiableListView<CourseUnit> get currUcs =>
      UnmodifiableListView(_currUcs);

  String get feesRefreshTime => _feesRefreshTime.toString();

  String get printRefreshTime => _printRefreshTime.toString();

  Profile get profile => _profile;

  updateStateBasedOnLocalProfile() async {
    final profileDb = AppUserDataDatabase();
    final Profile profile = await profileDb.getUserData();

    final AppCoursesDatabase coursesDb = AppCoursesDatabase();
    final List<Course> courses = await coursesDb.courses();

    profile.courses = courses;

    // Build courses states map
    final Map<String, String> coursesStates = <String, String>{};
    for (Course course in profile.courses) {
      coursesStates[course.name!] = course.state!;
    }

    _profile = profile;
    notifyListeners();
  }

  getUserFees(Completer<void> action, Session session) async {
    try {
      final response = await FeesFetcher().getUserFeesResponse(session);

      final String feesBalance = await parseFeesBalance(response);
      final String feesLimit = await parseFeesNextLimit(response);

      final DateTime currentTime = DateTime.now();
      final Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        await storeRefreshTime('fees', currentTime.toString());

        // Store fees info
        final profileDb = AppUserDataDatabase();
        profileDb.saveUserFees(Tuple2<String, String>(feesBalance, feesLimit));
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
    }

    action.complete();
  }

  Future storeRefreshTime(String db, String currentTime) async {
    final AppRefreshTimesDatabase refreshTimesDatabase =
        AppRefreshTimesDatabase();
    refreshTimesDatabase.saveRefreshTime(db, currentTime);
  }

  getUserPrintBalance(Completer<void> action, Session session) async {
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
    }

    action.complete();
  }

  updateStateBasedOnLocalRefreshTimes() async {
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

  getUserInfo(Completer<void> action, Session session) async {
    try {
      updateStatus(RequestStatus.busy);

      final profile = ProfileFetcher.getProfile(session).then((res) {
        _profile = res;
      });

      final ucs = CurrentCourseUnitsFetcher()
          .getCurrentCourseUnits(session)
          .then((res) => _currUcs = res);
      await Future.wait([profile, ucs]);
      notifyListeners();
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

  getCourseUnitsAndCourseAverages(
      Session session, Completer<void> action) async {
    updateStatus(RequestStatus.busy);
    try {
      final List<Course> courses = profile.courses;
      _currUcs = await AllCourseUnitsFetcher()
          .getAllCourseUnitsAndCourseAverages(courses, session);
      updateStatus(RequestStatus.successful);
      notifyListeners();

      final Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppCoursesDatabase coursesDb = AppCoursesDatabase();
        await coursesDb.saveNewCourses(courses);

        final courseUnitsDatabase = AppCourseUnitsDatabase();
        await courseUnitsDatabase.saveNewCourseUnits(currUcs);
      }
    } catch (e) {
      Logger().e('Failed to get all user ucs: $e');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  updateStateBasedOnLocalCourseUnits() async {
    final AppCourseUnitsDatabase db = AppCourseUnitsDatabase();
    _currUcs = await db.courseUnits();
    notifyListeners();
  }
}
