import 'dart:convert';

import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/session.dart';

/// Returns the user's current list of [CourseUnit].
class CoursesFetcher {
  static Future<List<CourseUnit>> getCurrentCourseUnits(Session session) async {
    final url = NetworkRouter.getBaseUrlsFromSession(session)[0] +
        'mob_fest_geral.ucurr_inscricoes_corrente?';
    final response = await NetworkRouter.getWithCookies(
        url, {'pv_codigo': session.studentNumber}, session);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<CourseUnit> ucs = <CourseUnit>[];
      for (var course in responseBody) {
        for (var uc in course['inscricoes']) {
          ucs.add(CourseUnit.fromJson(uc));
        }
      }
      return ucs;
    }
    return <CourseUnit>[];
  }
}
