import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/course.dart';

/// Manages the app's Courses database.
///
/// This database stores information about the user's courses.
/// See the [Course] class to see what data is stored in this database.
class AppCoursesDatabase extends AppDatabase {
  static const String createScript =
      '''CREATE TABLE courses(id INTEGER, fest_id INTEGER, name TEXT,
          abbreviation TEXT, currYear TEXT, firstEnrollment INTEGER, state TEXT, faculty TEXT)''';
  AppCoursesDatabase()
      : super('courses.db', [createScript], onUpgrade: migrate, version: 2);

  /// Replaces all of the data in this database with the data from [courses].
  saveNewCourses(List<Course> courses) async {
    await deleteCourses();
    await _insertCourses(courses);
  }

  /// Returns a list containing all of the courses stored in this database.
  Future<List<Course>> courses() async {
    // Get a reference to the database
    final Database db = await getDatabase();

    // Query the table for All The Courses.
    final List<Map<String, dynamic>> maps = await db.query('courses');

    // Convert the List<Map<String, dynamic> into a List<Course>.
    return List.generate(maps.length, (i) {
      return Course(
          id: maps[i]['id'],
          festId: maps[i]['fest_id'],
          name: maps[i]['name'],
          abbreviation: maps[i]['abbreviation'],
          currYear: maps[i]['currYear'],
          firstEnrollment: maps[i]['firstEnrollment'],
          state: maps[i]['state'],
          faculty: maps[i]['faculty']);
    });
  }

  /// Adds all items from [courses] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertCourses(List<Course> courses) async {
    for (Course course in courses) {
      await insertInDatabase(
        'courses',
        course.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteCourses() async {
    final Database db = await getDatabase();
    await db.delete('courses');
  }

  /// Migrates [db] from [oldVersion] to [newVersion].
  ///
  /// *Note:* This operation only updates the schema of the tables present in
  /// the database and, as such, all data is lost.
  static FutureOr<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS courses');
    batch.execute(createScript);
  }
}
