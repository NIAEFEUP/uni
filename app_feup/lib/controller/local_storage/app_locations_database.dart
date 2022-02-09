import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';



import 'app_database.dart';

class LocationDatabase extends AppDatabase {
  LocationDatabase()
      : super('location.db',
      ['''CREATE TABLE LOCATION_GROUP(
          id INTEGER PRIMARY KEY, 
          lat TEXT, 
          lng TEXT, 
          is_floorless INTEGER)''',
        '''CREATE TABLE LOCATIONS(
          id INTEGER PRIMARY KEY, 
          floor INTEGER,  
          name TEXT ,  
          first_room TEXT, 
          last_room TEXT, 
          id_location_group, 
          FOREIGN KEY (id_location_group) REFERENCES LOCATION_GROUP(id)
         )''']);

    initLocations(List<LocationGroup> locations) async {
      final Database db = await this.getDatabase();
      await db.transaction((txn)  async {
        locations.forEach((group) => saveLocationGroup(txn, group));
      });
    }

    saveLocationGroup(Transaction t, LocationGroup group){
      t.insert('location_group', group.toMap());
      final List<Location> locations =
        group.floors.values.expand((x) => x).toList();
      locations.forEach((location) { 
        t.insert('locations', location.toMap(groupId: group.id));
      });
    }




}