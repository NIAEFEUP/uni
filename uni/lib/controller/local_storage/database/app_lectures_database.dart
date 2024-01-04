import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/lecture.dart';

/// Manages the app's Lectures database.
///
/// This database stores information about the user's lectures.
/// See the [Lecture] class to see what data is stored in this database.
class AppLecturesDatabase extends AppDatabase {
  AppLecturesDatabase()
      : super(
          'lectures.db',
          [
            createScript,
          ],
          onUpgrade: migrate,
          version: 7,
        );
  static const createScript = '''
CREATE TABLE lectures(subject TEXT, typeClass TEXT,
          startDateTime TEXT, blocks INTEGER, room TEXT, teacher TEXT, classNumber TEXT, occurrId INTEGER)''';

  /// Replaces all of the data in this database with [lectures].
  Future<void> saveNewLectures(List<Lecture> lectures) async {
    await deleteLectures();
    await _insertLectures(lectures);
  }

  /// Returns a list containing all of the lectures stored in this database.
  Future<List<Lecture>> lectures() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('lectures');

    return List.generate(maps.length, (i) {
      return Lecture.fromApi(
        maps[i]['subject'] as String,
        maps[i]['typeClass'] as String,
        DateTime.parse(maps[i]['startDateTime'] as String),
        maps[i]['blocks'] as int,
        maps[i]['room'] as String,
        maps[i]['teacher'] as String,
        maps[i]['classNumber'] as String,
        maps[i]['occurrId'] as int,
      );
    });
  }

  /// Adds all items from [lecs] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertLectures(List<Lecture> lecs) async {
    for (final lec in lecs) {
      await insertInDatabase(
        'lectures',
        lec.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteLectures() async {
    // Get a reference to the database
    final db = await getDatabase();

    await db.delete('lectures');
  }

  /// Migrates [db] from [oldVersion] to [newVersion].
  ///
  /// *Note:* This operation only updates the schema of the tables present in
  /// the database and, as such, all data is lost.
  static FutureOr<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = db.batch()
      ..execute('DROP TABLE IF EXISTS lectures')
      ..execute(createScript);
    await batch.commit();
  }
}
