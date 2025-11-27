import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/providers/riverpod/calendar_provider.dart';
import 'package:uni/model/providers/riverpod/course_units_info_provider.dart';
import 'package:uni/model/providers/riverpod/exam_provider.dart';
import 'package:uni/model/providers/riverpod/faculty_locations_provider.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';
import 'package:uni/model/providers/riverpod/library_occupation_provider.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/restaurant_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

Future<void> cleanupStoredData(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  await Future.wait([PreferencesController.removeSavedSession()]);

  Database().clear();
  await Database().remove();

  final toCleanDirectory = await getApplicationDocumentsDirectory();
  await cleanDirectory(toCleanDirectory, DateTime.now());

  if (context.mounted) {
    ProviderScope.containerOf(context)
      ..invalidate(sessionProvider)
      ..invalidate(profileProvider)
      ..invalidate(restaurantProvider)
      ..invalidate(lectureProvider)
      ..invalidate(examProvider)
      ..invalidate(courseUnitsInfoProvider)
      ..invalidate(libraryProvider)
      ..invalidate(locationsProvider)
      ..invalidate(calendarProvider);
  }
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
      return fileDate.isBefore(threshold) &&
          path.extension(file.path) != '.mdb';
    } catch (err) {
      return false;
    }
  });

  for (final entity in toDeleteEntities) {
    entity.deleteSync();
  }
}
