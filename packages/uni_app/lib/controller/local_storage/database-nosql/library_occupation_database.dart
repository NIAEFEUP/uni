import 'package:uni/controller/local_storage/database-nosql/app_database.dart';
import 'package:uni/model/entities/floor_occupation.dart';

class LibraryOccupationDatabase extends NoSQLDatabase<FloorOccupation> {
  LibraryOccupationDatabase() : super('library_occupation');
}
