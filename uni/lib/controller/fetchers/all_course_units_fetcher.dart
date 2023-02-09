import 'package:logger/logger.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_units.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/session/sigarra_session.dart';

class AllCourseUnitsFetcher {
  Future<List<CourseUnit>> getAllCourseUnitsAndCourseAverages(
      List<Course> courses, Session session) async {
    final List<CourseUnit> allCourseUnits = [];
    for (var course in courses) {
      try {
        final List<CourseUnit> courseUnits =
            await _getAllCourseUnitsAndCourseAveragesFromCourse(
                course, session);
        allCourseUnits.addAll(courseUnits.where((c) => c.enrollmentIsValid()));
      } catch (e) {
        Logger().e('Failed to fetch course units for ${course.name}', e);
      }
    }
    return allCourseUnits;
  }

  Future<List<CourseUnit>> _getAllCourseUnitsAndCourseAveragesFromCourse(
      Course course, Session session) async {
    if (course.faculty == null) {
      return [];
    }
    final String url =
        '${NetworkRouter.getBaseUrl(course.faculty!)}fest_geral.curso_percurso_academico_view';
    final response = await NetworkRouter.getWithCookies(
        url,
        {
          'pv_fest_id': course.festId.toString(),
        },
        session);
    return parseCourseUnitsAndCourseAverage(response, course);
  }
}
