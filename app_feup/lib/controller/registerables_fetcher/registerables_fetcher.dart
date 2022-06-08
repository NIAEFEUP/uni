import 'package:uni/model/entities/course_unit.dart';

abstract class RegisterablesFetcher {
  Future<List<CourseUnit>> getRegisterables();
}