import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_unit_info.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/entities/session.dart';

class CourseUnitsInfoFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(session).toList();
    return urls;
  }

  Future<CourseUnitSheet> fetchCourseUnitSheet(
      Session session, int occurrId) async {
    // if course unit is not from the main faculty, Sigarra redirects
    final url = '${getEndpoints(session)[0]}ucurr_geral.ficha_uc_view';
    final response = await NetworkRouter.getWithCookies(
        url, {'pv_ocorrencia_id': occurrId.toString()}, session);
    return parseCourseUnitSheet(response);
  }

  Future<List<CourseUnitClass>> fetchCourseUnitClasses(
      Session session, int occurrId) async {
    for (final endpoint in getEndpoints(session)) {
      // Crawl classes from all courses that the course unit is offered in
      final String courseChoiceUrl =
          '${endpoint}it_listagem.lista_cursos_disciplina?pv_ocorrencia_id=$occurrId';
      final Response courseChoiceResponse =
          await NetworkRouter.getWithCookies(courseChoiceUrl, {}, session);
      final courseChoiceDocument = parse(courseChoiceResponse.body);
      final urls = courseChoiceDocument
          .querySelectorAll('a')
          .where((element) =>
              element.attributes['href'] != null &&
              element.attributes['href']!
                  .contains('it_listagem.lista_turma_disciplina'))
          .map((e) {
        var url = e.attributes['href'];
        if (url != null && !url.contains('sigarra.up.pt')) {
          url = endpoint + url;
        }
        return url;
      }).toList();

      for (final url in urls) {
        try {
          final Response response =
              await NetworkRouter.getWithCookies(url!, {}, session);
          return parseCourseUnitClasses(response, endpoint);
        } catch (_) {
          continue;
        }
      }
    }

    return [];
  }
}
