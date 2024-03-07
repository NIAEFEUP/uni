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

  await Future.wait([
    AppLecturesDatabase().deleteLectures(),
    AppExamsDatabase().deleteExams(),
    AppCoursesDatabase().deleteCourses(),
    AppUserDataDatabase().deleteUserData(),
    AppLastUserInfoUpdateDatabase().deleteLastUpdate(),
    AppBusStopDatabase().deleteBusStops(),
    AppCourseUnitsDatabase().deleteCourseUnits(),
    NetworkRouter.killSigarraAuthentication(faculties),
  ]);

  final toCleanDirectory = await getApplicationDocumentsDirectory();
  await cleanDirectory(toCleanDirectory, DateTime.now());
}

Future<void> cleanupCachedFiles() async {
  final lastCleanupDate = PreferencesController.getLastCleanUpDate();
  final daysSinceLastCleanup =
      DateTime.now().difference(lastCleanupDate).inDays;

  if (daysSinceLastCleanup < 14) {
    return;
  }

  final toCleanDirectory = await getApplicationDocumentsDirectory();
  final threshold = DateTime.now().subtract(const Duration(days: 30));

  await cleanDirectory(toCleanDirectory, threshold);

  await PreferencesController.setLastCleanUpDate(DateTime.now());
}

Future<void> cleanDirectory(Directory directory, DateTime threshold) async {
  final entities = directory.listSync(recursive: true, followLinks: false);
  final toDeleteEntities = entities.where((e) {
    try {
      final fileDate = File(e.path).lastModifiedSync();
      return fileDate.isBefore(threshold);
    } catch (e) {
      return false;
    }
  });

  for (final entity in toDeleteEntities) {
    await File(entity.path).delete();
  }
}
