import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
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
import 'package:uni/model/providers/state_providers.dart';

Future<void> cleanupStoredData(BuildContext context) async {
  StateProviders.fromContext(context).invalidate();

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  await Future.wait([
    AppLecturesDatabase().deleteLectures(),
    AppExamsDatabase().deleteExams(),
    AppCoursesDatabase().deleteCourses(),
    AppUserDataDatabase().deleteUserData(),
    AppLastUserInfoUpdateDatabase().deleteLastUpdate(),
    AppBusStopDatabase().deleteBusStops(),
    AppCourseUnitsDatabase().deleteCourseUnits(),
    PreferencesController.removeSavedSession(),
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
  final toDeleteEntities = entities.whereType<File>().where((file) {
    try {
      final fileDate = file.lastModifiedSync();
      return fileDate.isBefore(threshold) && path.extension(file.path) != '.db';
    } catch (err) {
      return false;
    }
  });

  for (final entity in toDeleteEntities) {
    entity.deleteSync();
  }
}
