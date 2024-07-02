import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

/// Manages a generic database.
///
/// This class is the foundation for all other database managers.
class AppDatabase {
  AppDatabase(this.name, this.commands, {this.onUpgrade, this.version = 1});

  /// An instance of this database.
  Database? _db;

  /// The name of this database.
  String name;

  /// A list of commands to be executed on database creation.
  List<String> commands;

  /// The lock timeout for database operations.
  static const Duration lockTimeout = Duration(seconds: 5);

  /// A lock that synchronizes all database insertions.
  static Lock lock = Lock();

  /// A function that is called when the [version] changes.
  final OnDatabaseVersionChangeFn? onUpgrade;

  /// The version of this database.
  final int version;

  /// Returns an instance of this database.
  Future<Database> getDatabase() async {
    _db ??= await initializeDatabase();
    return _db!;
  }

  /// Inserts [values] into the corresponding [table] in this database.
  Future<void> insertInDatabase(
    String table,
    Map<String, dynamic> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    await lock.synchronized(
      () async {
        final db = await getDatabase();

        await db.insert(
          table,
          values,
          nullColumnHack: nullColumnHack,
          conflictAlgorithm: conflictAlgorithm,
        );
      },
      timeout: lockTimeout,
    );
  }

  /// Initializes this database.
  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database
    final directory = await getDatabasesPath();
    final path = join(directory, name);

    // Open or create the database at the given path
    final appDatabase = await openDatabase(
      path,
      version: version,
      onCreate: _createDatabase,
      onUpgrade: onUpgrade,
    );
    return appDatabase;
  }

  /// Executes the commands present in [commands].
  Future<void> _createDatabase(Database db, int newVersion) async {
    for (final command in commands) {
      await db.execute(command);
    }
  }

  /// Removes the database called [name].
  static Future<void> removeDatabase(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + name;

    await deleteDatabase(path);
  }
}
