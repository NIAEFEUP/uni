import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/library_occupation.dart';

class LibraryOccupationDatabase extends AppDatabase {
  LibraryOccupationDatabase()
      : super('occupation.db', [
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
      for (var floor in occupation.floors) {
        await txn.insert('FLOOR_OCCUPATION', floor.toJson());
      }
    });
  }

  Future<LibraryOccupation> occupation() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('floor_occupation');

    final LibraryOccupation occupation = LibraryOccupation(0, 0);

    for (int i = 0; i < maps.length; i++) {
      occupation.addFloor(FloorOccupation(
          maps[i]['number'], maps[i]['occupation'], maps[i]['capacity']));
    }

    return occupation;
  }
}
