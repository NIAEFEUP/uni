import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/reference.dart';

/// Manages the app's References database.
///
/// This database stores information about the user's references.
/// See the [Reference] class to see what data is stored in this database.
class AppReferencesDatabase extends AppDatabase<List<Reference>> {
  AppReferencesDatabase()
      : super(
          'refs.db',
          [createScript],
          onUpgrade: migrate,
          version: 2,
        );
  static const String createScript =
      '''CREATE TABLE refs(description TEXT, entity INTEGER, '''
      '''reference INTEGER, amount REAL, limitDate TEXT)''';

  /// Returns a list containing all the references stored in this database.
  Future<List<Reference>> references() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('refs');

    return List.generate(maps.length, (i) {
      return Reference.fromJson(maps[i]);
    });
  }

  /// Deletes all of the data in this database.
  Future<void> deleteReferences() async {
    final db = await getDatabase();
    await db.delete('refs');
  }

  /// Adds all items from [references] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> insertReferences(List<Reference> references) async {
    for (final reference in references) {
      await insertInDatabase(
        'refs',
        reference.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// the database and, as such, all data is lost.
  static FutureOr<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = db.batch()
      ..execute('DROP TABLE IF EXISTS refs')
      ..execute(createScript);
    await batch.commit();
  }

  /// Replaces all of the data in this database with the data from [data].
  @override
  Future<void> saveToDatabase(List<Reference> data) async {
    await deleteReferences();
    await insertReferences(data);
  }
}
