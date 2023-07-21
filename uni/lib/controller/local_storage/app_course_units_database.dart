import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

class AppCourseUnitsDatabase extends AppDatabase {
  AppCourseUnitsDatabase() : super('course_units.db', [createScript]);
  static const String createScript =
      '''CREATE TABLE course_units(id INTEGER, code TEXT, abbreviation TEXT,'''
      '''name TEXT, curricularYear INTEGER, occurrId INTEGER, semesterCode TEXT,'''
      '''semesterName TEXT, type TEXT, status TEXT, grade TEXT, ectsGrade TEXT,'''
      '''result TEXT, ects REAL, schoolYear TEXT)''';

  saveNewCourseUnits(List<CourseUnit> courseUnits) async {
    await deleteCourseUnits();
    await _insertCourseUnits(courseUnits);
  }

  Future<List<CourseUnit>> courseUnits() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('course_units');

    return List.generate(maps.length, (i) {
      return CourseUnit(
        id: maps[i]['id'],
        code: maps[i]['code'],
        abbreviation: maps[i]['abbreviation'],
        name: maps[i]['name'],
        curricularYear: maps[i]['curricularYear'],
        occurrId: maps[i]['occurrId'],
        semesterCode: maps[i]['semesterCode'],
        semesterName: maps[i]['semesterName'],
        type: maps[i]['type'],
        status: maps[i]['status'],
        grade: maps[i]['grade'],
        ectsGrade: maps[i]['ectsGrade'],
        result: maps[i]['result'],
        ects: maps[i]['ects'],
        schoolYear: maps[i]['schoolYear'],
      );
    });
  }

  Future<void> _insertCourseUnits(List<CourseUnit> courseUnits) async {
    for (final courseUnit in courseUnits) {
      await insertInDatabase(
        'course_units',
        courseUnit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteCourseUnits() async {
    final db = await getDatabase();
    await db.delete('course_units');
  }
}
