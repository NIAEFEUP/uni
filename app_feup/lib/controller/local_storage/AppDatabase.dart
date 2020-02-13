import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class AppDatabase {
  Database _db;
  String name;
  List<String> commands;
  static Lock lock = new Lock();

  AppDatabase(String name, List<String> commands) {
    this.name = name;
    this.commands = commands;
  }

  Future<Database> getDatabase() async {
    if (_db == null) _db = await initializeDatabase();
    return _db;
  }

  insertInDatabase(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm}) async {
    lock.synchronized(() async {
      Database db = await getDatabase();

      db.insert(table, values,
          nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
    });
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database
    Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path + this.name;

    // Open or create the database at the given path
    var appFeupDatabase =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return appFeupDatabase;
  }

  void _createDatabase(Database db, int newVersion) async {
    for (String command in commands) {
      await db.execute(command);
    }
  }

  static removeDatabase(String name) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path + name;

    await deleteDatabase(path);
  }
}
