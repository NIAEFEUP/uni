import 'package:uni/controller/local_storage/database-nosql/app_database.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

class CourseUnitsDatabase extends NoSQLDatabase<CourseUnit> {
  CourseUnitsDatabase() : super('course_units');
}
