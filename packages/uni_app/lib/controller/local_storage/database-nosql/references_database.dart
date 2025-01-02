import 'package:uni/controller/local_storage/database-nosql/app_database.dart';
import 'package:uni/model/entities/reference.dart';

class ReferencesDatabase extends NoSQLDatabase<Reference> {
  ReferencesDatabase() : super('references');
}
