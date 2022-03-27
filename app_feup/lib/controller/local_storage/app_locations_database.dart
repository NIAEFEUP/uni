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
          type TEXT ,
          name TEXT ,  
          first_room TEXT, 
          last_room TEXT, 
          id_location_group, 
          FOREIGN KEY (id_location_group) REFERENCES LOCATION_GROUP(id) ON DELETE CASCADE
         )''']);

    initLocations(List<LocationGroup> locations) async {
      final Database db = await this.getDatabase();
      final batch = db.batch();
      batch.delete('location_group');
      batch.delete('locations');
      locations.forEach((group) => saveLocationGroup(batch, group));
      await batch.commit(noResult: true);

      /*await db.transaction((txn)  async {
        db.delete('location_group');
        db.delete('locations');
        locations.forEach((group) => saveLocationGroup(txn, group));
      });
      */
    }
  /*
  saveLocationGroup(Transaction t, LocationGroup group){
    t.insert('location_group', group.toMap());
    final List<Location> locations =
    group.floors.values.expand((x) => x).toList();
    locations.forEach((location) {
      t.insert('locations', location.toMap(groupId: group.id));
    });
  }*/
  saveLocationGroup(Batch batch, LocationGroup group){
    batch.insert('location_group', group.toMap());
    final List<Location> locations =
    group.floors.values.expand((x) => x).toList();
    locations.forEach((location) {
      batch.insert('locations', location.toMap(groupId: group.id));
    });
  }






}