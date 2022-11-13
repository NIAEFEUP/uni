import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/exam.dart';

/// Manages the app's Exams database.
///
/// This database stores information about the user's exams.
/// See the [Exam] class to see what data is stored in this database.
class AppExamsDatabase extends AppDatabase {
  var months = {
    'Janeiro': '01',
    'Fevereiro': '02',
    'Março': '03',
    'Abril': '04',
    'Maio': '05',
    'Junho': '06',
    'Julho': '07',
    'Agosto': '08',
    'Setembro': '09',
    'Outubro': '10',
    'Novembro': '11',
    'Dezembro': '12'
  };

  static const _createScript =
      '''CREATE TABLE exams(id TEXT, subject TEXT, begin TEXT, end TEXT,
          rooms TEXT, day TEXT, examType TEXT, weekDay TEXT, month TEXT, year TEXT) ''';

  AppExamsDatabase()
      : super('exams.db', [_createScript], onUpgrade: migrate, version: 2);

  /// Replaces all of the data in this database with [exams].
  saveNewExams(List<Exam> exams) async {
    await deleteExams();
    await _insertExams(exams);
  }

  /// Returns a list containing all of the exams stored in this database.
  Future<List<Exam>> exams() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('exams');

    return List.generate(maps.length, (i) {
      return Exam.secConstructor(
          maps[i]['id'] ?? 0,
          maps[i]['subject'],
          DateTime.parse(maps[i]['year'] +
              '-' +
              months[maps[i]['month']] +
              '-' +
              maps[i]['day'] +
              ' ' +
              maps[i]['begin']),
          DateTime.parse(maps[i]['year'] +
              '-' +
              months[maps[i]['month']] +
              '-' +
              maps[i]['day'] +
              ' ' +
              maps[i]['end']),

          maps[i]['rooms'] ?? '',

          maps[i]['rooms'],

          maps[i]['examType']);
    });
  }

  /// Adds all items from [exams] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertExams(List<Exam> exams) async {
    for (Exam exam in exams) {
      await insertInDatabase(
        'exams',
        exam.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteExams() async {
    // Get a reference to the database
    final Database db = await getDatabase();
    await db.delete('exams');
  }

  static FutureOr<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS exams');
    batch.execute(_createScript);
  }
}
