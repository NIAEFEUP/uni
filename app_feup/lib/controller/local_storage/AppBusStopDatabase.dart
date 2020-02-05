import 'dart:async';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:app_feup/model/entities/Bus.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:sqflite/sqflite.dart';

class AppBusStopDatabase extends AppDatabase{

  AppBusStopDatabase():super('busstops.db', 'CREATE TABLE busstops(stopCode TEXT, busCodes TEXT, favorited TEXT)');

  Future<List<BusStop>> busStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for all bus stops
    final List<Map<String, dynamic>> maps = await db.query('busstops');
    if(maps.length == 0)
      return new List();

    final List<BusStop> stops = new List();
    maps.forEach((stop) => stops.add(BusStop(stopCode: stop['stopCode'], buses: stop['busCodes'].split(",").map<Bus>((code) => Bus(busCode: code)).toList(), favorited: stop['favorited'] == '0' ? false : true)));
    return stops;
  }

  Future<void> updateFavoriteBusStop(String favStop) async {
    final List<BusStop> stops = await busStops();
    for(BusStop stop in stops) {
      if(stop.stopCode == favStop)
        stop.favorited = !stop.favorited;
    }

    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> addBusStop(BusStop newStop) async {
    final List<BusStop> stops = await busStops();
    stops.add(newStop);

    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> removeBusStop(BusStop removedStop) async {
    final List<BusStop> stops = await busStops();
    print("Removing " + removedStop.stopCode);
    for (int i = 0; i < stops.length; i++) {
      if(stops[i].stopCode == removedStop.stopCode)
        stops.remove(stops[i]);
    }
    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> _insertBusStops(List<BusStop> stops) async {
    for (BusStop stop in stops) {
      await insertInDatabase(
        'busstops',
        {'stopCode': stop.stopCode,
          'busCodes': stop.buses.map((bus)=>bus.busCode).join(","),
          'favorited': stop.favorited,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> _deleteBusStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    await db.delete('busstops');
  }

  Future<void> setBusStops(List<BusStop> busStops) async{
    await _deleteBusStops();
    await _insertBusStops(busStops);
  }
}