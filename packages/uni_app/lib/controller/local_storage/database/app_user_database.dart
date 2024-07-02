import 'dart:async';

import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/profile.dart';

/// Manages the app's User Data database.
///
/// This database stores information about the user's university profile.
class AppUserDataDatabase extends AppDatabase {
  AppUserDataDatabase()
      : super('userdata.db', ['CREATE TABLE userdata(key TEXT, value TEXT)']);

  /// Adds [profile] to this database.
  Future<void> insertUserData(Profile profile) async {
    for (final keymap in profile.keymapValues()) {
      await insertInDatabase(
        'userdata',
        {'key': keymap.item1, 'value': keymap.item2},
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
      if (entry['key'] == 'name') {
        name = entry['value'] as String;
      }
      if (entry['key'] == 'email') {
        email = entry['value'] as String;
      }
      if (entry['key'] == 'printBalance') {
        printBalance = entry['value'] as String;
      }
      if (entry['key'] == 'feesBalance') {
        feesBalance = entry['value'] as String;
      }
      if (entry['key'] == 'feesLimit') {
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

  /// Saves the user's print balance to the database.
  Future<void> saveUserPrintBalance(String userBalance) async {
    await insertInDatabase(
      'userdata',
      {'key': 'printBalance', 'value': userBalance},
    );
  }

  /// Saves the user's balance and payment due date to the database.
  ///
  Future<void> saveUserFees(String feesBalance, DateTime? feesLimit) async {
    await insertInDatabase(
      'userdata',
      {'key': 'feesBalance', 'value': feesBalance},
    );
    await insertInDatabase('userdata', {
      'key': 'feesLimit',
      'value': feesLimit != null ? feesLimit.toIso8601String() : '',
    });
  }
}
