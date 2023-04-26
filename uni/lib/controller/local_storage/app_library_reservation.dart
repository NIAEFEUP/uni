import 'package:sqflite/sqflite.dart';
import 'package:uni/model/entities/library_reservation.dart';

import 'package:uni/controller/local_storage/app_database.dart';

class LibraryReservationDatabase extends AppDatabase {
  LibraryReservationDatabase()
      : super('reservations.db', [
          '''CREATE TABLE RESERVATION(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        room TEXT,
        startDate TEXT,
        duration_hours INT,
        duration_minutes INT
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

    final List<Map<String, dynamic>> items = await db.query('RESERVATION');

    final List<LibraryReservation> reservations = [];

    for (int i = 0; i < items.length; i++) {
      final int minutes = items[i]['duration'];
      reservations.add(LibraryReservation(
          items[i]['id'],
          items[i]['room'],
          DateTime.parse(items[i]['startDate']),
          Duration(hours: minutes ~/ 60, minutes: minutes % 60)));
    }

    return reservations;
  }
}
