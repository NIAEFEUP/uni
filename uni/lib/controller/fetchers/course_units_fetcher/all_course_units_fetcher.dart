
import 'package:logger/logger.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_units.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/session.dart';

class AllCourseUnitsFetcher {
  Future<List<CourseUnit>?> getAllCourseUnitsAndCourseAverages(
    List<Course> courses,
    Session session, {
    List<CourseUnit>? currentCourseUnits,
  }) async {
    final allCourseUnits = <CourseUnit>[];

    for (final course in courses) {
      final courseUnits = await _getAllCourseUnitsAndCourseAveragesFromCourse(
        course,
        session,
        currentCourseUnits: currentCourseUnits,
      );
      allCourseUnits.addAll(courseUnits.where((c) => c.enrollmentIsValid()));
    }

    return allCourseUnits;
  }

  Future<List<CourseUnit>> _getAllCourseUnitsAndCourseAveragesFromCourse(
    Course course,
    Session session, {
    List<CourseUnit>? currentCourseUnits,
  }) async {
    final url = '${NetworkRouter.getBaseUrl(course.faculty!)}'
        'fest_geral.curso_percurso_academico_view';
    final response = await NetworkRouter.getWithCookies(
      url,
      {
        'pv_fest_id': course.festId.toString(),
      },
      session,
    );
    return parseCourseUnitsAndCourseAverage(
      response,
      course,
      currentCourseUnits: currentCourseUnits,
    );
  }
}
