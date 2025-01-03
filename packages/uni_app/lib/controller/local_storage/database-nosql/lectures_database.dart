import 'package:uni/controller/local_storage/database-nosql/app_database.dart';
import 'package:uni/model/entities/lecture.dart';

class LecturesDatabase extends NoSQLDatabase<Lecture> {
  LecturesDatabase() : super('lectures');
}
