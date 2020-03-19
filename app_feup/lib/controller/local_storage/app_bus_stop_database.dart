import 'dart:async';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:collection/collection.dart';
import 'package:uni/model/entities/bus_stop.dart';

class AppBusStopDatabase extends AppDatabase {
  AppBusStopDatabase()
      : super('busstops.db', [
          'CREATE TABLE busstops(stopCode TEXT, busCode TEXT)',
          'CREATE TABLE favoritestops(stopCode TEXT, favorited TEXT)'
        ]);
  Future<Map<String, BusStopData>> busStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();

    // Query the table for all bus stops
    final List<Map<String, dynamic>> buses = await db.query('busstops');

    final List<Map<String, dynamic>> favoritesQueryResult =
        await db.query('favoritestops');

    final Map<String, bool> favorites =  Map();
    favoritesQueryResult
        .forEach((e) => favorites[e['stopCode']] = e['favorited'] == '1');

    final Map<String, BusStopData> stops =  Map();
    groupBy(buses, (stop) => stop['stopCode']).forEach(
        (stopCode, busCodeList) => stops[stopCode] = BusStopData(
            configuredBuses:  Set<String>.from(
                busCodeList.map((busEntry) => busEntry['busCode'])),
            favorited: favorites[stopCode]));
    return stops;
  }

  Future<void> updateFavoriteBusStop(String stopCode) async {
    final Map<String, BusStopData> stops = await busStops();
    stops[stopCode].favorited = !stops[stopCode].favorited;
    await deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> addBusStop(String stopCode, BusStopData stopData) async {
    final Map<String, BusStopData> stops = await busStops();
    stops[stopCode] = stopData;
    await deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> removeBusStop(String stopCode) async {
    final Map<String, BusStopData> stops = await busStops();
    stops.remove(stopCode);
    await deleteBusStops();
    await _insertBusStops(stops);
  }

  Future<void> _insertBusStops(Map<String, BusStopData> stops) async {
    stops.forEach((stopCode, stopData) async {
      await insertInDatabase('favoritestops',
          {'stopCode': stopCode, 'favorited': stopData.favorited});
      stopData.configuredBuses.forEach((busCode) async {
        await insertInDatabase(
          'busstops',
          {
            'stopCode': stopCode,
            'busCode': busCode,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    });
  }

  Future<void> deleteBusStops() async {
    // Get a reference to the database
    final Database db = await this.getDatabase();
    await db.delete('busstops');
  }

  Future<void> setBusStops(Map<String, BusStopData> stops) async {
    await deleteBusStops();
    await _insertBusStops(stops);
  }
}
