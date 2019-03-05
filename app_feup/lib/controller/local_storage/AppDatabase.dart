import 'dart:async';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static Future<Database> _dbLectures;

  saveNewLectures(List<Lecture> lecs) async {
    await _openDBLectures();
    await _deleteLectures();
    await _insertLectures(lecs);
  }

  Future<List<Lecture>> lectures() async {
    // Get a reference to the database
    final Database db = await _dbLectures;

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

  _openDBLectures() async {
    if (_dbLectures == null)
      _dbLectures = openDatabase(
        join(await getDatabasesPath(), 'lectures.db'),
        onCreate: (db, version) {
          return db.execute("CREATE TABLE lectures(subject TEXT, typeClass TEXT, day INTEGER, startTimeSeconds INTEGER, blocks INTEGER, room TEXT, teacher TEXT)");
        },
        version: 1,
      );
  }

  Future<void> _insertLectures(List<Lecture> lecs) async {
    // Get a reference to the database
    final Database db = await _dbLectures;

    for (Lecture lec in lecs)
      await db.insert(
        'lectures',
        lec.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<void> _deleteLectures() async {
    // Get a reference to the database
    final Database db = await _dbLectures;

    await db.delete('lectures');
  }
}