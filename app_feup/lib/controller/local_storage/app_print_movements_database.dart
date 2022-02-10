import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';

/// Manages the app's Print Movements database.
///
/// This database stores information about the user's print movements
class AppPrintMovementsDatabase extends AppDatabase {
  AppPrintMovementsDatabase()
      : super('print_movements.db', [
          'CREATE TABLE movements(datetime DATETIME, value TEXT)',
        ]);

  Future<List> printMovements() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for all movements
    final List movements = await db.query('movements');

    return movements;
  }

  /// Adds all entries from [movements] to this database.
  Future<void> _insertPrintMovements(List movements) async {
    movements.forEach((movement) async {
      await insertInDatabase(
        'movements',
        {'datetime': movement['datetime'], 'value': movement['value']},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Deletes all of the movements from this database.
  Future<void> deletePrintMovements() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    await db.delete('movements');
  }

  /// Replaces all the movements in this database with entries
  /// from [movements].
  Future<void> setPrintMovements(List movements) async {
    await deletePrintMovements();
    await _insertPrintMovements(movements);
  }
}
