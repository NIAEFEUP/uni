import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';

class AppRefreshTimesDatabase extends AppDatabase {
  AppRefreshTimesDatabase()
      : super('refreshtimes.db',
            ['CREATE TABLE refreshtimes(event TEXT, time TEXT)']);

  Future<Map<String, String>> refreshTimes() async {
    final Database db = await this.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('refreshtimes');

    final Map<String, String> refreshTimes =  Map<String, String>();
    for (Map<String, dynamic> entry in maps) {
      if (entry['event'] == 'print') refreshTimes['print'] = entry['time'];
      if (entry['event'] == 'fees') refreshTimes['fees'] = entry['time'];
    }

    return refreshTimes;
  }

  Future<void> deleteRefreshTimes() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('refreshtimes');
  }

  void saveRefreshTime(String event, String time) async {
    final Database db = await this.getDatabase();

    final List<Map> maps =
        await db.query('refreshtimes', where: 'event = ?', whereArgs: [event]);

    // New element
    if (maps.isEmpty) {
      await insertInDatabase('refreshtimes', {'event': event, 'time': time});
    }
    // Update element
    else {
      await db.update(
        'refreshtimes',
        {'time': time},
        where: 'event = ?',
        whereArgs: [event],
      );
    }
    // store date ou julian days ou smt else
  }
}
