import 'app_database.dart';

class AppLastUserInfoUpdateDatabase extends AppDatabase {
  AppLastUserInfoUpdateDatabase()
      : super('last_update.db', ['CREATE TABLE last_update(lastUpdate DATE)']);

  insertNewTimeStamp(DateTime timestamp) async {
    await deleteLastUpdate();
    await _insertTimeStamp(timestamp);
  }

  deleteLastUpdate() async {
    final db = await this.getDatabase();

    await db.delete('last_update');
  }

  _insertTimeStamp(DateTime timestamp) async {
    final db = await this.getDatabase();

    await db.transaction((txn) async {
      await txn
          .insert('last_update', {'lastUpdate': timestamp.toIso8601String()});
    });
  }

  Future<DateTime> getLastUserInfoUpdateTime() async {
    final db = await this.getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('last_update');

    if (maps.length > 0) {
      return DateTime.parse(maps[0]['lastUpdate']);
    }
    return null;
  }
}
