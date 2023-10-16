import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/session.dart';

abstract class AllCourseUnitsFetcher implements SessionDependantFetcher {
  Future<List<Course>> getCourses(Session session);
}
