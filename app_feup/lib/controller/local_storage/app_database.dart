import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

class AppDatabase {
  Database _db;
  String name;
  List<String> commands;
  static Lock lock = Lock();
  final OnDatabaseVersionChangeFn onUpgrade;
  final int version;

  AppDatabase(String name, List<String> commands,
      {this.onUpgrade, this.version = 1}) {
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
      final Database db = await getDatabase();

      db.insert(table, values,
          nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
    });
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database
    final String directory = await getDatabasesPath();
    final String path = join(directory, this.name);

    // Open or create the database at the given path
    final appFeupDatabase = await openDatabase(path,
        version: version, onCreate: _createDatabase, onUpgrade: onUpgrade);
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
