import 'dart:async';

import 'package:sqflite/sqlite_api.dart';
import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/profile.dart';

/// Manages the app's User Data database.
///
/// This database stores information about the user's university profile.
class AppUserDataDatabase extends AppDatabase<Profile> {
  AppUserDataDatabase()
      : super(
          'userdata.db',
          ['CREATE TABLE userdata(name TEXT, value TEXT)'],
          onUpgrade: migrate,
          version: 2,
        );

  /// Adds [data] (profile) to this database.
  @override
  Future<void> saveToDatabase(Profile data) async {
    for (final keymap in data.keymapValues()) {
      await insertInDatabase(
        'userdata',
        {'name': keymap.item1, 'value': keymap.item2},
      );
    }
  }

  // Returns all of the data stored in this database.
  Future<Profile> getUserData() async {
    // Get a reference to the database
    final db = await getDatabase();

    // Query the table for all the user data
    final List<Map<String, dynamic>> maps = await db.query('userdata');

    // Convert the List<Map<String, dynamic> into a Profile.
    String? name;
    String? email;
    String? printBalance;
    String? feesBalance;
    DateTime? feesLimit;
    for (final entry in maps) {
      if (entry['name'] == 'name') {
        name = entry['value'] as String;
      }
      if (entry['name'] == 'email') {
        email = entry['value'] as String;
      }
      if (entry['name'] == 'printBalance') {
        printBalance = entry['value'] as String;
      }
      if (entry['name'] == 'feesBalance') {
        feesBalance = entry['value'] as String;
      }
      if (entry['name'] == 'feesLimit') {
        feesLimit = DateTime.tryParse(entry['value'] as String);
      }
    }

    return Profile(
      name: name ?? '?',
      email: email ?? '?',
      courses: <Course>[],
      printBalance: printBalance ?? '?',
      feesBalance: feesBalance ?? '?',
      feesLimit: feesLimit,
    );
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteUserData() async {
    // Get a reference to the database
    final db = await getDatabase();

    await db.delete('userdata');
  }

  static FutureOr<void> migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = db.batch()
      ..execute('DROP TABLE IF EXISTS userdata')
      ..execute('CREATE TABLE userdata(name TEXT, value TEXT)');
    await batch.commit();
  }
}
