import 'package:sqflite/sqflite.dart';
import 'package:uni/controller/local_storage/app_database.dart';
import 'package:uni/model/entities/calendar_event.dart';

class CalendarDatabase extends AppDatabase {
  CalendarDatabase()
      : super('calendar.bd', [
          '''
          CREATE TABLE CALENDAR(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            startDate INTEGER,
            endDate INTEGER)'''
        ]);

  void saveCalendar(List<CalendarEvent> calendar) async {
    final Database db = await this.getDatabase();
    db.transaction((txn) async {
      await txn.delete('CALENDAR');
      calendar.forEach((event) async {
        await txn.insert('CALENDAR', event.toMap());
      });
    });
  }
}
