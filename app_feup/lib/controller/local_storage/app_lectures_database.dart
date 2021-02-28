import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:sqflite/sqflite.dart';

class AppLecturesDatabase extends AppDatabase {
  static final createScript =
      '''CREATE TABLE lectures(subject TEXT, typeClass TEXT,
          day INTEGER, startTime TEXT, blocks INTEGER, room TEXT, teacher TEXT, classNumber TEXT)''';
  static final updateClassNumber = '''ALTER TABLE lectures ADD classNumber TEXT''';

  AppLecturesDatabase()
      : super(
            'lectures.db',
            [
              createScript,
            ],
            onUpgrade: migrate,
            version: 3);

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
      return Lecture.secConstructor(
        maps[i]['subject'],
        maps[i]['typeClass'],
        maps[i]['day'],
        maps[i]['startTime'],
        maps[i]['blocks'],
        maps[i]['room'],
        maps[i]['teacher'],
        maps[i]['classNumber'],
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

  static FutureOr<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    if (oldVersion == 1) {
      batch.execute('DROP TABLE IF EXISTS lectures');
      batch.execute(createScript);
    } else if (oldVersion == 2) {
      batch.execute(updateClassNumber);      
    }
    await batch.commit();
  }
}
