import 'dart:convert';

import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/session/flows/base/session.dart';

class CurrentCourseUnitsFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // all faculties list user course units on all faculties
    final url = '${NetworkRouter.getBaseUrlsFromSession(session)[0]}'
        'mob_fest_geral.ucurr_inscricoes_corrente';
    return [url];
  }

  Future<List<CourseUnit>> getCurrentCourseUnits(Session session) async {
    final url = getEndpoints(session)[0];
    final response = await NetworkRouter.getWithCookies(
      url,
      {'pv_codigo': session.username},
      session,
    );

    if (response.statusCode != 200) {
      return <CourseUnit>[];
    }

    final responseBody = json.decode(response.body) as List<dynamic>;

    final ucs = <CourseUnit>[];

    for (final course in responseBody) {
      final enrollments =
          (course as Map<String, dynamic>)['inscricoes'] as List<dynamic>;
      for (final uc in enrollments) {
        final courseUnit = CourseUnit.fromJson(uc as Map<String, dynamic>);
        ucs.add(courseUnit);
      }
    }

    return ucs;
  }
}
