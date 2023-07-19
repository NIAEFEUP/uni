import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/local_storage/app_database.dart';
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
    // TODO: Change profile keymap logic to avoid conflicts with print balance (#526)
    for (Tuple2<String, String> keymap in profile.keymapValues()) {
      await insertInDatabase(
          'userdata', {'key': keymap.item1, 'value': keymap.item2});
    }
  }

  // Returns all of the data stored in this database.
  Future<Profile> getUserData() async {
    // Get a reference to the database
    final Database db = await getDatabase();

    // Query the table for all the user data
    final List<Map<String, dynamic>> maps = await db.query('userdata');

    // Convert the List<Map<String, dynamic> into a Profile.
    String? name, email, printBalance, feesBalance;
    DateTime? feesLimit;
    for (Map<String, dynamic> entry in maps) {
      if (entry['key'] == 'name') name = entry['value'];
      if (entry['key'] == 'email') email = entry['value'];
      if (entry['key'] == 'printBalance') printBalance = entry['value'];
      if (entry['key'] == 'feesBalance') feesBalance = entry['value'];
      if (entry['key'] == 'feesLimit')
        feesLimit = DateTime.tryParse(entry['value']);
    }

    return Profile(
        name: name ?? '?',
        email: email ?? '?',
        courses: <Course>[],
        printBalance: printBalance ?? '?',
        feesBalance: feesBalance ?? '?',
        feesLimit: feesLimit);
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteUserData() async {
    // Get a reference to the database
    final Database db = await getDatabase();

    await db.delete('userdata');
  }

  /// Saves the user's print balance to the database.
  void saveUserPrintBalance(String userBalance) async {
    await insertInDatabase(
        'userdata', {'key': 'printBalance', 'value': userBalance});
  }

  /// Saves the user's balance and payment due date to the database.
  ///
  void saveUserFees(String feesBalance, DateTime? feesLimit) async {
    await insertInDatabase(
        'userdata', {'key': 'feesBalance', 'value': feesBalance});
    await insertInDatabase('userdata', {
      'key': 'feesLimit',
      'value': feesLimit != null ? feesLimit.toIso8601String() : ''
    });
  }
}
