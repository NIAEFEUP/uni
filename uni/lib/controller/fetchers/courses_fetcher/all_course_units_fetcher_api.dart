import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/courses_fetcher/all_course_units_fetcher.dart';
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
  Future<List<Course>> getCourses(Session session) async {
    final url = getEndpoints(session)[0];
    final response = await NetworkRouter.getWithCookies(
      url,
      {
        'pv_codigo': session.username,
      },
      session,
    );

    final allCourses = <Course>[];

    final responseCourses = jsonDecode(response.body) as List<dynamic>;
    for (final courseContent in responseCourses) {
      final courseData = courseContent as Map<String, dynamic>;
      final course = Course.fromJson(courseData);
      if (course != null) {
        allCourses.add(course);
      }
    }

    return allCourses;
  }
}
