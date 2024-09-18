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
      return CourseUnit(
        id: maps[i]['ucurr_id'] as int?,
        code: maps[i]['ucurr_codigo'] as String,
        abbreviation: maps[i]['ucurr_sigla'] as String,
        name: maps[i]['ucurr_nome'] as String,
        curricularYear: maps[i]['ano'] as int?,
        occurrId: maps[i]['ocorr_id'] as int,
        semesterCode: maps[i]['per_codigo'] as String?,
        semesterName: maps[i]['per_nome'] as String?,
        type: maps[i]['tipo'] as String?,
        status: maps[i]['estado'] as String?,
        grade: maps[i]['resultado_melhor'] as String?,
        ectsGrade: maps[i]['ectsGrade'] as String?,
        result: maps[i]['resultado_insc'] as String?,
        ects: maps[i]['creditos_ects'] as double?,
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
