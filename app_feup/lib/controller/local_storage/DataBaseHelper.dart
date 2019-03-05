import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _db;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> getDatabase() async {
    if (_db == null)
      _db = await initializeDatabase();
    return _db;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'appFeup.db';

    // Open or create the database at the given path
    var appFeupDatabase = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return appFeupDatabase;
  }

  void _createDatabase(Database db, int newVersion) async {

    // Create student table -- still incomplete -- needs to be discussed
    await db.execute('CREATE TABLE Student(id INTEGER PRIMARY KEY AUTOINCREMENT, student_code TEXT, '
        'forename TEXT, surname TEXT, current_year INTEGER, state TEXT, startedAt TEXT, '
        'photo_path TEXT)');

    // Create other tables
    // TODO
  }
}
