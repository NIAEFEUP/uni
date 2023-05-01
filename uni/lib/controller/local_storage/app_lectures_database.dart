import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:sqflite/sqflite.dart';

/// Manages the app's Lectures database.
///
/// This database stores information about the user's lectures.
/// See the [Lecture] class to see what data is stored in this database.
class AppLecturesDatabase extends AppDatabase {
  static const createScript =
      '''CREATE TABLE lectures(subject TEXT, typeClass TEXT,
          startDateTime TEXT, blocks INTEGER, room TEXT, teacher TEXT, classNumber TEXT, occurrId INTEGER)''';

  AppLecturesDatabase()
      : super(
            'lectures.db',
            [
              createScript,
            ],
            onUpgrade: migrate,
            version: 6);

  /// Replaces all of the data in this database with [lecs].
  saveNewLectures(List<Lecture> lecs) async {
    await deleteLectures();
    await _insertLectures(lecs);
  }

  /// Returns a list containing all of the lectures stored in this database.
  Future<List<Lecture>> lectures() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('lectures');

    return List.generate(maps.length, (i) {
      return Lecture.fromApi(
        maps[i]['subject'],
        maps[i]['typeClass'],
        maps[i]['startDateTime'],
        maps[i]['blocks'],
        maps[i]['room'],
        maps[i]['teacher'],
        maps[i]['classNumber'],
        maps[i]['occurrId'],
      );
    });
  }

  /// Adds all items from [lecs] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertLectures(List<Lecture> lecs) async {
    for (Lecture lec in lecs) {
      await insertInDatabase(
        'lectures',
        lec.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteLectures() async {
    // Get a reference to the database
    final Database db = await getDatabase();

    await db.delete('lectures');
  }

  /// Migrates [db] from [oldVersion] to [newVersion].
  ///
  /// *Note:* This operation only updates the schema of the tables present in
  /// the database and, as such, all data is lost.
  static FutureOr<void> migrate(
      Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS lectures');
    batch.execute(createScript);
    await batch.commit();
  }
}
