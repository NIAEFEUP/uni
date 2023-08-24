import 'package:uni/controller/local_storage/app_database.dart';
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

    final reservations = <LibraryReservation>[];

    for (var i = 0; i < items.length; i++) {
      final minutes = items[i]['duration'] as int;
      reservations.add(
        LibraryReservation(
          items[i]['room'] as String,
          DateTime.parse(items[i]['startDate'] as String),
          Duration(hours: minutes ~/ 60, minutes: minutes % 60),
        ),
      );
    }

    return reservations;
  }
}
