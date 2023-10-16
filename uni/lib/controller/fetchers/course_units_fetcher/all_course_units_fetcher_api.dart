import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/all_course_units_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/session.dart';

class AllCourseUnitsFetcherApi implements AllCourseUnitsFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // One with a multiple-faculty course will see
    // all course units in main faculty
    final url = '${NetworkRouter.getBaseUrl(session.faculties[0])}'
        'mob_fest_geral.percurso_academico';
    return [url];
  }

  @override
  Future<List<CourseUnit>?> getAllCourseUnitsAndCourseAverages(
    List<Course> courses,
    Session session, {
    List<CourseUnit>? currentCourseUnits,
  }) async {
    Logger().e("meu deus");
    final url = getEndpoints(session)[0];
    final response = await NetworkRouter.getWithCookies(
      url,
      {
        'pv_codigo': session.username,
      },
      session,
    );

    final allCourseUnits = <CourseUnit>[];

    final responseCourses = jsonDecode(response.body) as List<dynamic>;
    for (final courseContent in responseCourses) {
      final course = courseContent as Map<String, dynamic>;

      final correspondingCourse = courses.firstWhereOrNull(
        (c) => c.festId == course['fest_id'],
      );
      if (correspondingCourse == null) {
        continue;
      }

      correspondingCourse.currentAverage = course['media'] as double?;
      final courseCourseUnits = (course['inscricoes'] as List<dynamic>)
          .map((e) => CourseUnit.fromJson(e as Map<String, dynamic>))
          .toList();
      allCourseUnits.addAll(
        courseCourseUnits.whereNotNull().where((c) => c.enrollmentIsValid()),
      );
    }

    return allCourseUnits;
  }
}
