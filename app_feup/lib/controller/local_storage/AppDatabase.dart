import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class AppDatabase {
  Database _db;
  String name;
  String command;
  static Lock lock = new Lock();

  AppDatabase(String name, String command) {
    this.name = name;
    this.command = command;
  }

  Future<Database> getDatabase() async {
    if (_db == null)
      _db = await initializeDatabase();
    return _db;
  }

  insertInDatabase(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) async{

      lock.synchronized(() async {
        Database db = await getDatabase();

        db.insert(table, values, nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
      });
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + this.name;

    // Open or create the database at the given path
    var appFeupDatabase = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return appFeupDatabase;
  }

  void _createDatabase(Database db, int newVersion) async {
    await db.execute(command);
  }
}