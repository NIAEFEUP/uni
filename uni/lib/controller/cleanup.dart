import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/controller/local_storage/app_course_units_database.dart';
import 'package:uni/controller/local_storage/app_courses_database.dart';
import 'package:uni/controller/local_storage/app_exams_database.dart';
import 'package:uni/controller/local_storage/app_last_user_info_update_database.dart';
import 'package:uni/controller/local_storage/app_lectures_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/app_user_database.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/providers/state_providers.dart';

Future<void> cleanupStoredData(BuildContext context) async {
  StateProviders.fromContext(context).markAsNotInitialized();

  final prefs = await SharedPreferences.getInstance();
  final faculties = await AppSharedPreferences.getUserFaculties();
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

Future<void> cleanupCachedFiles() async {
  final lastCleanupDate = await AppSharedPreferences.getLastCleanUpDate();
  final daysSinceLastCleanup =
      DateTime.now().difference(lastCleanupDate).inDays;

  if (daysSinceLastCleanup < 14) {
    return;
  }

  final cacheManager = DefaultCacheManager();
  final cacheDirectory = await getApplicationDocumentsDirectory();
  final treshold = DateTime.now().subtract(const Duration(days: 30));

  final directories = cacheDirectory.listSync(followLinks: false);
  for (final directory in directories) {
    if (directory is Directory) {
      final files = directory.listSync(recursive: true, followLinks: false);

      final oldFiles = files.where((file) {
        try {
          final fileDate = File(file.path).lastModifiedSync();
          return fileDate.isBefore(treshold);
        } catch (e) {
          return false;
        }
      });

      for (final file in oldFiles) {
        await cacheManager.removeFile(file.path);
      }
    }
  }

  await AppSharedPreferences.setLastCleanUpDate(DateTime.now());
}
