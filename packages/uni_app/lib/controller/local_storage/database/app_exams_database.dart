import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/exam.dart';

/// Manages the app's Exams database.
///
/// This database stores information about the user's exams.
/// See the [Exam] class to see what data is stored in this database.
class AppExamsDatabase extends AppDatabase<List<Exam>> {
  AppExamsDatabase()
      : super('exams.db', [_createScript], onUpgrade: migrate, version: 7);

  static const _createScript = '''
CREATE TABLE exams(id TEXT, subject TEXT, start TEXT, finish TEXT,
          rooms TEXT, examType TEXT, faculty TEXT, PRIMARY KEY (id,faculty)) ''';

  /// Returns a list containing all of the exams stored in this database.
  Future<List<Exam>> exams() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('exams');

    return List.generate(maps.length, (i) {
      return Exam.secConstructor(
        maps[i]['id'] as String,
        maps[i]['subject'] as String,
        DateTime.parse(maps[i]['start'] as String),
        DateTime.parse(maps[i]['finish'] as String),
        maps[i]['rooms'] as String,
        maps[i]['examType'] as String,
        maps[i]['faculty'] as String,
      );
    });
  }

  /// Adds all items from [exams] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertExams(List<Exam> exams) async {
    for (final exam in exams) {
      final examJson = exam.toJson();
      examJson['rooms'] = (examJson['rooms'] as List<dynamic>).join(',');
      await insertInDatabase(
        'exams',
        examJson,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteExams() async {
    // Get a reference to the database
    final db = await getDatabase();
    await db.delete('exams');
  }

  static FutureOr<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = db.batch()
      ..execute('DROP TABLE IF EXISTS exams')
      ..execute(_createScript);
    await batch.commit();
  }

  /// Replaces all of the data in this database with [data].
  @override
  Future<void> saveToDatabase(List<Exam> data) async {
    await deleteExams();
    await _insertExams(data);
  }
}
