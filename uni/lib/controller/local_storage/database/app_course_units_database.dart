import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

class AppCourseUnitsDatabase extends AppDatabase {
  AppCourseUnitsDatabase() : super('course_units.db', [createScript]);
  static const String createScript =
      '''CREATE TABLE course_units(id INTEGER, code TEXT, abbreviation TEXT , '''
      '''name TEXT, curricularYear INTEGER, occurrId INTEGER, semesterCode TEXT, '''
      '''semesterName TEXT, type TEXT, status TEXT, grade TEXT, ectsGrade TEXT, '''
      '''result TEXT, ects REAL, schoolYear TEXT)''';

  Future<void> saveNewCourseUnits(List<CourseUnit> courseUnits) async {
    await deleteCourseUnits();
    await _insertCourseUnits(courseUnits);
  }

  Future<List<CourseUnit>> courseUnits() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('course_units');

    return List.generate(maps.length, (i) {
      return CourseUnit(
        id: maps[i]['id'] as int,
        code: maps[i]['code'] as String,
        abbreviation: maps[i]['abbreviation'] as String,
        name: maps[i]['name'] as String,
        curricularYear: maps[i]['curricularYear'] as int?,
        occurrId: maps[i]['occurrId'] as int,
        semesterCode: maps[i]['semesterCode'] as String?,
        semesterName: maps[i]['semesterName'] as String?,
        type: maps[i]['type'] as String?,
        status: maps[i]['status'] as String?,
        grade: maps[i]['grade'] as String?,
        ectsGrade: maps[i]['ectsGrade'] as String?,
        result: maps[i]['result'] as String?,
        ects: maps[i]['ects'] as double?,
        schoolYear: maps[i]['schoolYear'] as String?,
      );
    });
  }

  Future<void> _insertCourseUnits(List<CourseUnit> courseUnits) async {
    for (final courseUnit in courseUnits) {
      await insertInDatabase(
        'course_units',
        courseUnit.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteCourseUnits() async {
    final db = await getDatabase();
    await db.delete('course_units');
  }
}
