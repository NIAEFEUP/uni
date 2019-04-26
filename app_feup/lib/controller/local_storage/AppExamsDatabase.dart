import 'dart:async';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:app_feup/controller/parsers/ParserExams.dart';
import 'package:sqflite/sqflite.dart';

class AppExamsDatabase extends AppDatabase {

  AppExamsDatabase():super('exams.db', 'CREATE TABLE exams(subject TEXT, begin TEXT, end TEXT, rooms TEXT, day TEXT, examType TEXT, weekDay TEXT, month TEXT, year TEXT)');

  saveNewExams(List<Exam> exams) async {
    await _deleteExams();
    await _insertExams(exams);
  }

  Future<List<Exam>> exams() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('exams');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Exam.secConstructor(
        maps[i]['subject'],
        maps[i]['begin'],
        maps[i]['end'],
        maps[i]['rooms'],
        maps[i]['day'],
        maps[i]['examType'],
        maps[i]['weekDay'],
        maps[i]['month'],
        maps[i]['year']
      );
    });
  }

  Future<void> _insertExams(List<Exam> exams) async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    for (Exam exam in exams)
      await db.insert(
        'exams',
        exam.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<void> _deleteExams() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('exams');
  }
}