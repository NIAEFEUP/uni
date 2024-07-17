import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/course.dart';

/// Manages the app's Courses database.
///
/// This database stores information about the user's courses.
/// See the [Course] class to see what data is stored in this database.
class AppCoursesDatabase extends AppDatabase<List<Course>> {
  AppCoursesDatabase()
      : super('courses.db', [createScript], onUpgrade: migrate, version: 4);
  static const String createScript =
      '''CREATE TABLE courses(cur_id INTEGER, fest_id INTEGER, cur_nome TEXT, '''
      '''abbreviation TEXT, ano_curricular TEXT, fest_a_lect_1_insc INTEGER, state TEXT, '''
      '''inst_sigla TEXT, currentAverage REAL, finishedEcts REAL)''';

  /// Returns a list containing all of the courses stored in this database.
  Future<List<Course>> courses() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('courses');

    // Convert the List<Map<String, dynamic> into a List<Course>.
    return List.generate(maps.length, (i) {
      return Course(
        id: maps[i]['cur_id'] as int? ?? 0,
        festId: maps[i]['fest_id'] as int? ?? 0,
        name: maps[i]['cur_nome'] as String?,
        abbreviation: maps[i]['abbreviation'] as String?,
        currYear: maps[i]['ano_curricular'] as String?,
        firstEnrollment: maps[i]['fest_a_lect_1_insc'] as int? ?? 0,
        state: maps[i]['state'] as String?,
        faculty: maps[i]['inst_sigla'] as String?,
        finishedEcts: maps[i]['finishedEcts'] as double? ?? 0,
        currentAverage: maps[i]['currentAverage'] as double? ?? 0,
      );
    });
  }

  /// Adds all items from [courses] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertCourses(List<Course> courses) async {
    for (final course in courses) {
      await insertInDatabase(
        'courses',
        course.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteCourses() async {
    final db = await getDatabase();
    await db.delete('courses');
  }

  /// Migrates [db] from [oldVersion] to [newVersion].
  ///
  /// *Note:* This operation only updates the schema of the tables present in
  /// the database and, as such, all data is lost.
  static FutureOr<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = db.batch()
      ..execute('DROP TABLE IF EXISTS courses')
      ..execute(createScript);
    await batch.commit();
  }

  /// Replaces all of the data in this database with the data from [data].
  @override
  Future<void> saveToDatabase(List<Course> data) async {
    await deleteCourses();
    await _insertCourses(data);
  }
}
