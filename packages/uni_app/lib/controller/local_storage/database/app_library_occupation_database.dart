import 'package:uni/controller/local_storage/database/app_database.dart';
import 'package:uni/model/entities/library_occupation.dart';

class LibraryOccupationDatabase extends AppDatabase<LibraryOccupation> {
  LibraryOccupationDatabase()
      : super(
          'occupation.db',
          [
            '''
              CREATE TABLE FLOOR_OCCUPATION(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              number INT,
              occupation INT,
              capacity INT
              )
              '''
          ],
        );

  Future<LibraryOccupation> occupation() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('floor_occupation');

    final occupation = LibraryOccupation(0, 0);

    for (var i = 0; i < maps.length; i++) {
      occupation.addFloor(
        FloorOccupation.fromJson(maps[i]),
      );
    }

    return occupation;
  }

  @override
  Future<void> saveToDatabase(LibraryOccupation data) async {
    final db = await getDatabase();
    await db.transaction((txn) async {
      await txn.delete('FLOOR_OCCUPATION');
      for (final floor in data.floors) {
        await txn.insert('FLOOR_OCCUPATION', floor.toJson());
      }
    });
  }
}
