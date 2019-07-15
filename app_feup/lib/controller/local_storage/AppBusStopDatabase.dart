import 'dart:async';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:sqflite/sqflite.dart';

class AppBusStopDatabase extends AppDatabase{

  AppBusStopDatabase():super('busstops.db', 'CREATE TABLE busstops(id TEXT)');

  saveNewBusStops(List<BusStop> stops) async{
    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> _insertBusStops(List<BusStop> stops) async {

    for (BusStop stop in stops)
      await insertInDatabase(
        'busstops',
        stop.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<void> _deleteBusStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    await db.delete('busstops');
  }
}