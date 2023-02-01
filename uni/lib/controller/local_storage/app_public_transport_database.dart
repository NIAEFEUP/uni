
import 'dart:async';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';

class AppPublicTransportDatabase extends AppDatabase{
  AppPublicTransportDatabase() : super(
    "public-transport.db", 
    [
      "CREATE TABLE Stops (code TEXT PRIMARY KEY, name TEXT NOT NULL, longName TEXT, transportationType TEXT NOT NULL, latitude NOT NULL, longitude NOT NULL);",
      //routePatterns is stored as a json to simplify the database
      "CREATE TABLE Routes (code TEXT PRIMARY KEY, name TEXT NOT NULL, longName TEXT, transportationType TEXT NOT NULL, routePatterns TEXT NOT NULL);"
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

    Future<Set<Route>> routes(Map<String, Stop> stops) async{
      final Database db = await getDatabase();
      final List<Map<String, dynamic>> query = await db.query("Routes");

      final Set<Route> routes = {};

      for(Map<String,dynamic> e in query){
        routes.add(Route.fromMap(e, stops));
      }
      return routes;
    }

  


  static FutureOr<void> migrate(Database db, int oldVersion, int newVersion)async {
    final Batch batch = db.batch();
    batch.delete("Stops");
    batch.delete("Routes");
    await batch.commit();
  }

}