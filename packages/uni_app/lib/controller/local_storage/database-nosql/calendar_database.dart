import 'package:uni/controller/local_storage/database-nosql/app_database.dart';
import 'package:uni/model/entities/calendar_event.dart';

class CalendarDatabase extends NoSQLDatabase<CalendarEvent> {
  CalendarDatabase() : super('calendar_events');
}
