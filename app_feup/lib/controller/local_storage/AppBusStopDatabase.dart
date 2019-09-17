import 'dart:async';
import 'package:app_feup/controller/local_storage/AppDatabase.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/entities/Bus.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/model/entities/Trip.dart';
import 'package:sqflite/sqflite.dart';

class AppBusStopDatabase extends AppDatabase{

  AppBusStopDatabase():super('busstops.db', 'CREATE TABLE busstops(stopCode TEXT, busCode TEXT)');

  Future<List<BusStop>> busStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for All The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('busstops');

    /*return List.generate(maps.length, (i) {
      return BusStop.secConstructor(maps[i]['stopCode'], maps[i]['busCode']); //returns string value in key i
    });*/
    if(maps.length == 0)
      return new List();
    List<BusStop> stops = new List();
    List<Bus> currentStopBuses = new List();
    String prevStop = maps[0]['stopCode'];
    for(int i = 0; i < maps.length; i++) {
      if (maps[i]['stopCode'] != prevStop) {
        stops.add(BusStop.secConstructor(prevStop, currentStopBuses));
        currentStopBuses.clear();
        prevStop = maps[i]['stopCode'];
        currentStopBuses.add(Bus.secConstructor(maps[i]['busCode']));
      }
      else {
        currentStopBuses.add(Bus.secConstructor(maps[i]['busCode']));
      }
      if (i == maps.length - 1) {
        stops.add(BusStop.secConstructor(prevStop, currentStopBuses));
      }
    }
    return stops;
  }

  Future<void> addBusStop(BusStop newStop) async {
    List<BusStop> stops = await busStops();
    stops.add(newStop);
    print("Adding " + newStop.getStopCode());
    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> removeBusStop(BusStop removedStop) async {
    List<BusStop> stops = await busStops();
    print("Removing " + removedStop.getStopCode());
    for (int i = 0; i < stops.length; i++) {
      if(stops[i].getStopCode() == removedStop.getStopCode())
        stops.remove(stops[i]);
    }
    await _deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> _insertBusStops(List<BusStop> stops) async {
    for (BusStop stop in stops) {
      for (Bus bus in stop.getBuses()) {
        await insertInDatabase(
          'busstops',
          {'stopCode': stop.getStopCode(),
            'busCode': bus.busCode
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

  Future<void> _deleteBusStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    await db.delete('busstops');
  }
}