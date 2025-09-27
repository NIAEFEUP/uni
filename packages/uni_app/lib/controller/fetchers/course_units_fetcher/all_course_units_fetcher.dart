import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_units.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/session/flows/base/session.dart';

class AllCourseUnitsFetcher {
  Future<List<CourseUnit>?> getAllCourseUnitsAndCourseAverages(
    List<Course> courses,
    Session session, {
    List<CourseUnit>? currentCourseUnits,
  }) async {
    final courseCourseUnits = await Future.wait(
      courses
          .map(
            (course) => _getAllCourseUnitsAndCourseAveragesFromCourse(
              course,
              session,
              currentCourseUnits: currentCourseUnits,
            ),
          )
          .toList(),
    );

    return courseCourseUnits
        .expand((l) => l)
        .where((c) => c.enrollmentIsValid())
        .toList();
  }

  Future<List<CourseUnit>> _getAllCourseUnitsAndCourseAveragesFromCourse(
    Course course,
    Session session, {
    List<CourseUnit>? currentCourseUnits,
  }) async {
    final academicPathUrl =
        '${NetworkRouter.getBaseUrl(course.faculty!)}'
        'fest_geral.curso_percurso_academico_view';
    final curricularUnitsUrl =
        '${NetworkRouter.getBaseUrl(course.faculty!)}'
        'fest_geral.ucurr_inscricoes_list';
    final responseAcademicPath = await NetworkRouter.getWithCookies(
      academicPathUrl,
      {'pv_fest_id': course.festId.toString()},
      session,
    );
    final responseCurricularUnits = await NetworkRouter.getWithCookies(
      curricularUnitsUrl,
      {'pv_fest_id': course.festId.toString()},
      session,
    );
    return parseCourseUnitsAndCourseAverage(
      responseAcademicPath,
      responseCurricularUnits,
      course,
      currentCourseUnits: currentCourseUnits,
    );
  }
}
