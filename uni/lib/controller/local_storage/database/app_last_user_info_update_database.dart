import 'package:uni/controller/local_storage/database/app_database.dart';

/// Manages the app's Last User Info Update database.
///
/// This database stores information about when the app last fetched and updated
/// the user's data.
class AppLastUserInfoUpdateDatabase extends AppDatabase {
  AppLastUserInfoUpdateDatabase()
      : super('last_update.db', ['CREATE TABLE last_update(lastUpdate DATE)']);

  /// Replaces the timestamp in this database with [timestamp].
  Future<void> insertNewTimeStamp(DateTime timestamp) async {
    await deleteLastUpdate();
    await _insertTimeStamp(timestamp);
  }

  /// Deletes all of the data from this database.
  Future<void> deleteLastUpdate() async {
    final db = await getDatabase();
    await db.delete('last_update');
  }

  /// Replaces the timestamp of the last user info update with [timestamp].
  Future<void> _insertTimeStamp(DateTime timestamp) async {
    final db = await getDatabase();

    await db.transaction((txn) async {
      await txn
          .insert('last_update', {'lastUpdate': timestamp.toIso8601String()});
    });
  }

  /// Returns the timestamp of the last user info update.
  Future<DateTime> getLastUserInfoUpdateTime() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('last_update');

    if (maps.isNotEmpty) {
      return DateTime.parse(maps[0]['lastUpdate'] as String);
    }
    return DateTime.now();
  }
}
