import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_units.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/session.dart';

class AllCourseUnitsFetcher {
  Future<List<CourseUnit>> getAllCourseUnits(
      List<Course> courses, Session session) async {
    List<CourseUnit> allCourseUnits = [];
    for (var course in courses) {
      allCourseUnits
          .addAll(await _getAllCourseUnitsFromCourse(course, session));
    }
    return allCourseUnits;
  }

  Future<List<CourseUnit>> _getAllCourseUnitsFromCourse(
      Course course, Session session) async {
    String url =
        '${NetworkRouter.getBaseUrl(course.faculty)}fest_geral.curso_percurso_academico_view';
    final response = await NetworkRouter.getWithCookies(
        url,
        {
          'pv_fest_id': course.festId.toString(),
        },
        session);
    return parseCourseUnits(response);
  }
}
