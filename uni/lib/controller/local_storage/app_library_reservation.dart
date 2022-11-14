import 'package:uni/model/entities/library_reservation.dart';

import 'app_database.dart';

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
}