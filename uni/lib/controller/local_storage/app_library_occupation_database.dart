import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/library_occupation.dart';

class OccupationDatabase extends AppDatabase {
  OccupationDatabase()
    : super('occupation.db', 
    [
      '''CREATE TABLE FLOOR_OCCUPATION(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        number INT,
        occupation INT,
        capacity INT
      )
      '''
    ]);

  void saveOccupation(LibraryOccupation occupation) async {
    final db = await getDatabase();
    db.transaction((txn) async {
      await txn.delete('FLOOR_OCCUPATION');
      occupation.getFloors().forEach((floor) async { 
        await txn.insert('FLOOR_OCCUPATION', floor.toMap());
      });
    });
  }
}