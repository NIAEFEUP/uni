import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/library_reservation.dart';

import 'package:uni/controller/local_storage/app_database.dart';

class LibraryReservationDatabase extends AppDatabase {
  LibraryReservationDatabase()
    : super('reservations.db', 
    [
      '''CREATE TABLE RESERVATION(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        room TEXT,
        startDate INT,
        duration INT
      )
      '''
    ]);

  void saveReservations(List<LibraryReservation> reservations) async {
    final db = await getDatabase();
    db.transaction((txn) async {
      await txn.delete('RESERVATION');
      for (var reservation in reservations) { 
        await txn.insert('RESERVATION', reservation.toMap());
      }
    });
  }
  
  Future<List<LibraryReservation>> reservations() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('reservation');

    final List<LibraryReservation> reservations = [];

    for (int i = 0; i < maps.length; i++) {
      reservations.add(LibraryReservation(
        maps[i]['room'], 
        maps[i]['startDate'], 
        maps[i]['duration']
      ));
    }

    return reservations;
  }
}