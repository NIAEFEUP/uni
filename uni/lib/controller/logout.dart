import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/controller/local_storage/app_course_units_database.dart';
import 'package:uni/controller/local_storage/app_courses_database.dart';
import 'package:uni/controller/local_storage/app_exams_database.dart';
import 'package:uni/controller/local_storage/app_last_user_info_update_database.dart';
import 'package:uni/controller/local_storage/app_lectures_database.dart';
import 'package:uni/controller/local_storage/app_refresh_times_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/app_user_database.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final faculties = await AppSharedPreferences.getUserFaculties();
  await prefs.clear();
  unawaited(
    Future.wait([
      AppLecturesDatabase().deleteLectures(),
      AppExamsDatabase().deleteExams(),
      AppCoursesDatabase().deleteCourses(),
      AppRefreshTimesDatabase().deleteRefreshTimes(),
      AppUserDataDatabase().deleteUserData(),
      AppLastUserInfoUpdateDatabase().deleteLastUpdate(),
      AppBusStopDatabase().deleteBusStops(),
      AppCourseUnitsDatabase().deleteCourseUnits(),
      NetworkRouter.killSigarraAuthentication(faculties),
    ]),
  );

  final path = (await getApplicationDocumentsDirectory()).path;
  final directory = Directory(path);
  if (directory.existsSync()) {
    directory.deleteSync(recursive: true);
  }
  GeneralPageViewState.profileImageProvider = null;
  PaintingBinding.instance.imageCache.clear();
}
