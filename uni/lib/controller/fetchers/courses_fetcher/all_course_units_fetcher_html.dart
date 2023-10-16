import 'package:http/http.dart';
import 'package:uni/controller/fetchers/courses_fetcher/all_course_units_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_units.dart';
import 'package:uni/controller/parsers/parser_courses.dart';
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
  Future<List<Course>> getCourses(Session session) async {
    final courses = await _fetchCoursesFromHtml(session);

    for (final course in courses) {
      final courseUnits = await _getAllCourseUnitsFromCourse(
        course,
        session,
      );
      course.courseUnits = courseUnits;
    }

    return courses;
  }

  Future<List<Course>> _fetchCoursesFromHtml(Session session) async {
    final coursesResponses = await Future.wait(
      _getCoursesListResponses(session),
    );
    return parseMultipleCourses(coursesResponses);
  }

  List<Future<Response>> _getCoursesListResponses(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(session)
        .map((url) => '${url}fest_geral.cursos_list?')
        .toList();
    return urls
        .map(
          (url) => NetworkRouter.getWithCookies(
            url,
            {'pv_num_unico': session.username},
            session,
          ),
        )
        .toList();
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
