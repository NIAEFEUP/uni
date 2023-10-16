import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/all_course_units_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_units.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/session.dart';

class AllCourseUnitsFetcherHtml implements AllCourseUnitsFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final url = '${NetworkRouter.getBaseUrl(session.faculties[0])}'
        'fest_geral.curso_percurso_academico_view';
    return [url];
  }

  @override
  Future<List<CourseUnit>?> getAllCourseUnitsAndCourseAverages(
    List<Course> courses,
    Session session, {
    List<CourseUnit>? currentCourseUnits,
  }) async {
    Logger().e("meu deus2");
    final allCourseUnits = <CourseUnit>[];

    for (final course in courses) {
      final courseUnits = await _getAllCourseUnitsFromCourse(
        course,
        session,
        currentCourseUnits: currentCourseUnits,
      );
      allCourseUnits.addAll(courseUnits.where((c) => c.enrollmentIsValid()));
    }

    return allCourseUnits;
  }

  Future<List<CourseUnit>> _getAllCourseUnitsFromCourse(
    Course course,
    Session session, {
    List<CourseUnit>? currentCourseUnits,
  }) async {
    final url = getEndpoints(session)[0];
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
