import 'dart:convert';

import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/session.dart';

class CurrentCourseUnitsFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // all faculties list user course units on all faculties
    final url =
        '${NetworkRouter.getBaseUrlsFromSession(session)[0]}mob_fest_geral.ucurr_inscricoes_corrente';
    return [url];
  }

  Future<List<CourseUnit>> getCurrentCourseUnits(Session session) async {
    final url = getEndpoints(session)[0];
    final response = await NetworkRouter.getWithCookies(
        url, {'pv_codigo': session.studentNumber}, session);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<CourseUnit> ucs = <CourseUnit>[];
      for (var course in responseBody) {
        for (var uc in course['inscricoes']) {
          final CourseUnit? courseUnit = CourseUnit.fromJson(uc);
          if (courseUnit != null) {
            ucs.add(courseUnit);
          }
        }
      }
      return ucs;
    }
    return <CourseUnit>[];
  }
}
