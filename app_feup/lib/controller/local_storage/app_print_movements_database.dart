import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';

/// Manages the app's Bus Stops database.
///
/// This database stores information about the bus stops that the user
/// wants to keep track of. It also stores information about
/// which ones are the user's favorite stops.
class AppPrintMovementsDatabase extends AppDatabase {
  AppPrintMovementsDatabase()
      : super('print_movements.db', [
          'CREATE TABLE movements(day TEXT, hour TEXT, value TEXT)',
        ]);

  Future<List> printMovements() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for all movements
    final List movements = await db.query('movements.db');

    return movements;
  }

  /// Adds all entries from [movements] to this database.
  Future<void> _insertPrintMovements(List movements) async {
    movements.forEach((movement) async {
      await insertInDatabase(
        'print_movements',
        {
          'date': movement['date'],
          'hour': movement['hour'],
          'value': movement['value']
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Deletes all of the movements from this database.
  Future<void> deletePrintMovements() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    await db.delete('print_movements');
  }

  /// Replaces all the movements in this database with entries
  /// from [movements].
  Future<void> setPrintMovements(List movements) async {
    await deletePrintMovements();
    await _insertPrintMovements(movements);
  }
}
