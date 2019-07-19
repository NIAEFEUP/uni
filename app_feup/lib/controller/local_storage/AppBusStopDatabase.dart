import 'dart:async';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:sqflite/sqflite.dart';

class AppBusStopDatabase extends AppDatabase{

  AppBusStopDatabase():super('busstops.db', 'CREATE TABLE busstops(stopCode TEXT)');

  saveNewBusStops(List<String> stops) async{
    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<List<String>> busStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('busstops');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return maps[i]['id']; //returns string value in key i
    });
  }

  Future<void> _insertBusStops(List<String> stops) async {

    for (String stop in stops)
      await insertInDatabase(
        'busstops',
        {'stopCode': stop},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<void> _deleteBusStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('busstops');
  }
}