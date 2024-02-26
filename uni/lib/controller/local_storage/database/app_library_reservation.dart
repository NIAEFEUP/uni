import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/library_reservation.dart';

class LibraryReservationDatabase extends AppDatabase {
  LibraryReservationDatabase()
      : super('reservations.db', [
          '''
        CREATE TABLE RESERVATION(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        room TEXT,
        startDate TEXT,
        duration INT
      )
      '''
        ]);

  Future<void> saveReservations(List<LibraryReservation> reservations) async {
    final db = await getDatabase();
    await db.transaction((txn) async {
      await txn.delete('RESERVATION');
      for (final reservation in reservations) {
        await txn.insert('RESERVATION', reservation.toMap());
      }
    });
  }

  Future<List<LibraryReservation>> reservations() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> items = await db.query('RESERVATION');

    return items.map((item) {
      final minutes = item['duration'] as int;
      return LibraryReservation(
        item['room'] as String,
        DateTime.parse(item['startDate'] as String),
        Duration(hours: minutes ~/ 60, minutes: minutes % 60),
      );
    }).toList();
  }
}
