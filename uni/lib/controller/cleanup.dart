import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/local_storage/database/app_bus_stop_database.dart';
import 'package:uni/controller/local_storage/database/app_course_units_database.dart';
import 'package:uni/controller/local_storage/database/app_courses_database.dart';
import 'package:uni/controller/local_storage/database/app_exams_database.dart';
import 'package:uni/controller/local_storage/database/app_last_user_info_update_database.dart';
import 'package:uni/controller/local_storage/database/app_lectures_database.dart';
import 'package:uni/controller/local_storage/database/app_user_database.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/providers/state_providers.dart';

Future<void> cleanupStoredData(BuildContext context) async {
  StateProviders.fromContext(context).invalidate();

  final prefs = await SharedPreferences.getInstance();
  final faculties = PreferencesController.getUserFaculties();
  await prefs.clear();

  unawaited(
    Future.wait([
      AppLecturesDatabase().deleteLectures(),
      AppExamsDatabase().deleteExams(),
      AppCoursesDatabase().deleteCourses(),
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
}
