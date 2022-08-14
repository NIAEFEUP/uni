import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show DefaultCacheManager;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/controller/local_storage/app_course_units_database.dart';
import 'package:uni/controller/local_storage/app_courses_database.dart';
import 'package:uni/controller/local_storage/app_exams_database.dart';
import 'package:uni/controller/local_storage/app_last_user_info_update_database.dart';
import 'package:uni/controller/local_storage/app_lectures_database.dart';
import 'package:uni/controller/local_storage/app_refresh_times_database.dart';
import 'package:uni/controller/local_storage/app_user_database.dart';
import 'package:uni/view/Common/PagesLayouts/General/general.dart';

Future logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  AppLecturesDatabase().deleteLectures();
  AppExamsDatabase().deleteExams();
  AppCoursesDatabase().deleteCourses();
  AppRefreshTimesDatabase().deleteRefreshTimes();
  AppUserDataDatabase().deleteUserData();
  AppLastUserInfoUpdateDatabase().deleteLastUpdate();
  AppBusStopDatabase().deleteBusStops();
  AppCourseUnitsDatabase().deleteCourseUnits();

  final path = (await getApplicationDocumentsDirectory()).path;
  (File('$path/profile_pic.png')).delete();
  GeneralPageViewState.decorageImage = null;
  PaintingBinding.instance.imageCache.clear();
  DefaultCacheManager().emptyCache();
}
