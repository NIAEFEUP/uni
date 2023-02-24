
import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/favorite_trip.dart';
import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';

class AppPublicTransportDatabase extends AppDatabase{
  AppPublicTransportDatabase() : super(
    "public-transport.db", 
    [
      "CREATE TABLE Stops (code TEXT PRIMARY KEY, name TEXT NOT NULL, longName TEXT, transportationType TEXT NOT NULL, latitude REAL NOT NULL, longitude REAL NOT NULL, providerName TEXT NOT NULL);",
      //routePatterns is stored as a json to simplify the database
      "CREATE TABLE Routes (code TEXT PRIMARY KEY, name TEXT NOT NULL, longName TEXT, transportationType TEXT NOT NULL, routePatterns TEXT NOT NULL, providerName TEXT NOT NULL);",
      //id is the name of the route that the user provided, otherwise is a generated id by the app
      //routeDesc is in a json format too
      "CREATE TABLE FavoriteTrips(id TEXT PRIMARY KEY, routeDescription TEXT NOT NULL)"
    ],
    onUpgrade: migrate, 
    version: 1);


  Future<Map<String, Stop>> stops() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> query = await db.query("Stops");

    final Map<String,Stop> stops = {};

    for(Map<String,dynamic> e in query){
      stops.putIfAbsent(e['code'], () => Stop.fromMap(e));
    }
    return stops;
  }

  Future<Map<String,Route>> routes(Map<String, Stop> stops) async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> query = await db.query("Routes");

    final Map<String,Route> routes = {};

    for(Map<String,dynamic> e in query){
      final Route route = Route.fromMap(e, stops);
      routes.putIfAbsent(route.code, () => route);
    }
    return routes;
  }

  Future<List<FavoriteTrip>> favoriteTrips(Map<String, Stop> stops, Map<String, Route> routes) async{
    final Database db = await getDatabase();
    final List<Map<String,dynamic>> query = await db.query("FavoriteTrips");

    final List<FavoriteTrip> favoriteTrips = query.map((e) => FavoriteTrip.fromMap(e, stops, routes)).toList();

    return favoriteTrips;
  }



  Future<void> insertStops(Map<String,Stop> stops) async{
    final Database db = await getDatabase();
    final Batch batch = db.batch();
    for (var element in stops.values) {
      batch.insert("Stops", 
        element.toMap(), 
        conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
  }

  Future<void> insertRoutes(Map<String,Route> routes) async{
    final Database db = await getDatabase();
    final Batch batch = db.batch();
    for (var element in routes.values) {
      batch.insert("Routes", 
        element.toMap(), 
        conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  Future<void> insertFavoriteTrips(List<FavoriteTrip> favoriteTrips) async{
    final Database db = await getDatabase();
    final Batch batch = db.batch();
    for(var element in favoriteTrips){
      batch.insert("FavoriteTrips", 
      element.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }



static FutureOr<void> migrate(Database db, int oldVersion, int newVersion)async {
  final Batch batch = db.batch();
  batch.delete("Stops");
  batch.delete("Routes");
  batch.delete("FavoriteTrips");
  await batch.commit();
}

}