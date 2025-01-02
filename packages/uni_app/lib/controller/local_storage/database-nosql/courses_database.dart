import 'package:uni/controller/local_storage/database-nosql/app_database.dart';
import 'package:uni/model/entities/course.dart';

class CoursesDatabase extends NoSQLDatabase<Course> {
  CoursesDatabase() : super('courses');
}
