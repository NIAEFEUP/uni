import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:sqflite/sqflite.dart';

class AppLecturesDatabase extends AppDatabase {
  AppLecturesDatabase()
      : super('lectures.db', [
          '''CREATE TABLE lectures(subject TEXT, typeClass TEXT,
          day INTEGER, startTimeSeconds INTEGER, blocks INTEGER, room TEXT, teacher TEXT)'''
        ]);

  saveNewLectures(List<Lecture> lecs) async {
    await deleteLectures();
    await _insertLectures(lecs);
  }

  Future<List<Lecture>> lectures() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('lectures');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Lecture(
        maps[i]['subject'],
        maps[i]['typeClass'],
        maps[i]['day'],
        maps[i]['startTimeSeconds'],
        maps[i]['blocks'],
        maps[i]['room'],
        maps[i]['teacher'],
      );
    });
  }

  Future<void> _insertLectures(List<Lecture> lecs) async {
    for (Lecture lec in lecs) {
      await this.insertInDatabase(
        'lectures',
        lec.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteLectures() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('lectures');
  }
}
