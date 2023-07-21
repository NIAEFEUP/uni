import 'dart:async';

import 'package:uni/controller/local_storage/app_database.dart';

/// Manages the app's Refresh Times database.
///
/// This database stores information about when certain data was updated
/// for the last time.
class AppRefreshTimesDatabase extends AppDatabase {
  AppRefreshTimesDatabase()
      : super(
          'refreshtimes.db',
          ['CREATE TABLE refreshtimes(event TEXT, time TEXT)'],
        );

  /// Returns a map containing all the data stored in this database.
  ///
  /// *Note:*
  /// * a key in this map is an event type.
  /// * a value in this map is the timestamp at which the data of the given type
  /// was last updated.
  Future<Map<String, String>> refreshTimes() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('refreshtimes');

    final refreshTimes = <String, String>{};
    for (final entry in maps) {
      if (entry['event'] == 'print') {
        refreshTimes['print'] = entry['time'] as String;
      }
      if (entry['event'] == 'fees') {
        refreshTimes['fees'] = entry['time'] as String;
      }
    }

    return refreshTimes;
  }

  /// Deletes all of the data from this database.
  Future<void> deleteRefreshTimes() async {
    // Get a reference to the database
    final db = await getDatabase();

    await db.delete('refreshtimes');
  }

  /// Updates the time stored for an [event].
  Future<void> saveRefreshTime(String event, String time) async {
    final db = await getDatabase();

    final maps =
        await db.query('refreshtimes', where: 'event = ?', whereArgs: [event]);

    if (maps.isEmpty) {
      await insertInDatabase('refreshtimes', {'event': event, 'time': time});
    } else {
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
