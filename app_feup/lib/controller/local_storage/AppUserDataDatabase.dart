import 'dart:async';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:app_feup/model/entities/Profile.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';

class AppUserDataDatabase extends AppDatabase {

  AppUserDataDatabase():super('userdata.db', 'CREATE TABLE userdata(key TEXT, value TEXT)');

  saveUserData(Profile profile) async {
    await _deleteUserData();
    await _insertUserData(profile);
  }

  Future<void> _insertUserData(Profile profile) async {

    for (Tuple2<String, String> keymap in profile.keymapValues())
      await insertInDatabase(
          'userdata',
          {"key" : keymap.item1,
           "value" : keymap.item2}
          );
  }

  Future<Profile> userdata() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for all the user data
    final List<Map<String, dynamic>> maps = await db.query('userdata');

    // Convert the List<Map<String, dynamic> into a Profile.
    String name, email;
    for (Map<String, dynamic> entry in maps) {
      if (entry['key'] == 'name')
        name = entry['value'];
      if (entry['key'] == 'email')
        email = entry['value'];
    }

    return Profile.secConstructor(name, email, List<Course>());
  }

  Future<void> _deleteUserData() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('userdata');
  }
}