import 'package:uni/model/entities/course_unit_class.dart';

abstract class ClassFetcher {
  Future<List<CourseUnitClass>> getClasses(int occurrId);
}