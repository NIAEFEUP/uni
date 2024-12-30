import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

class AppCourseUnitsDatabase extends AppDatabase<List<CourseUnit>> {
  AppCourseUnitsDatabase()
      : super(
          'course_units.db',
          [createScript],
          onUpgrade: migrate,
          version: 2,
        );
  static const String createScript =
      '''CREATE TABLE course_units(ucurr_id INTEGER, ucurr_codigo TEXT, ucurr_sigla TEXT , '''
      '''ucurr_nome TEXT, ano INTEGER, ocorr_id INTEGER, per_codigo TEXT, '''
      '''per_nome TEXT, tipo TEXT, estado TEXT, resultado_melhor TEXT, resultado_ects TEXT, '''
      '''ectsGrade TEXT, resultado_insc TEXT, creditos_ects REAL, schoolYear TEXT)''';

  Future<List<CourseUnit>> courseUnits() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('course_units');
    return List.generate(maps.length, (i) {
      return CourseUnit.fromJson(maps[i]);
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

  static FutureOr<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = db.batch()
      ..execute('DROP TABLE IF EXISTS course_units')
      ..execute(createScript);
    await batch.commit();
  }

  @override
  Future<void> saveToDatabase(List<CourseUnit> data) async {
    await deleteCourseUnits();
    await _insertCourseUnits(data);
  }
}
