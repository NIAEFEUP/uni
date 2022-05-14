import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:uni/model/entities/bus_stop.dart';

/// Manages the app's Schedule Planner database.
/// 
/// This database stores information about the schedule planning that the user
/// wants to keep track of.
class AppPlannedScheduleDatabase extends AppDatabase {

  static final schedulePlannerTable = '''CREATE TABLE scheduleoption(id INTEGER PRIMARY KEY AUTOINCREMENT, scheduleName TEXT, preference INTEGER UNIQUE)''';
  static final selectedCoursesPlanner ='''CREATE TABLE selectedCourses(id INTEGER PRIMARY KEY AUTOINCREMENT, schedule INTEGER FOREIGN KEY NOT NULL, class INTEGER FOREIGN KEY NOT NULL)''';
  static final classes ='''CREATE TABLE class(id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT NOT NULL, courseName TEXT NOT NULL)''';

  static final createScript = [
    schedulePlannerTable,
    selectedCoursesPlanner,
    classes
  ];

  AppPlannedScheduleDatabase()
      : super('scheduleplanner.db', createScript);

  /// Adds all items from [lecs] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<int> createSchedule(String scheduleName) async {

  }
}
