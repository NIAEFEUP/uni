import 'package:html/parser.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_unit_info.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/entities/session.dart';

class CourseUnitsInfoFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    return NetworkRouter.getBaseUrlsFromSession(session).toList();
  }

  Future<CourseUnitSheet> fetchCourseUnitSheet(
    Session session,
    int occurrId,
  ) async {
    // if course unit is not from the main faculty, Sigarra redirects
    final url = '${getEndpoints(session)[0]}ucurr_geral.ficha_uc_view';
    final response = await NetworkRouter.getWithCookies(
      url,
      {'pv_ocorrencia_id': occurrId.toString()},
      session,
    );
    return parseCourseUnitSheet(response);
  }

  Future<List<CourseUnitFileDirectory>> fetchCourseUnitFiles(
    Session session,
    int occurId,
  ) async {
    final url = '${getEndpoints(session)[0]}mob_ucurr_geral.conteudos';
    final response = await NetworkRouter.getWithCookies(
      url,
      {
        'pv_ocorrencia_id': occurId.toString(),
      },
      session,
    );
    return parseFiles(response, session);
  }

  Future<String> getDownloadLink(
    Session session,
  ) async {
    return '${getEndpoints(session)[0]}conteudos_service.conteudos_cont';
  }

  Future<List<CourseUnitClass>> fetchCourseUnitClasses(
    Session session,
    int occurrId,
  ) async {
    var courseUnitClasses = <CourseUnitClass>[];

    for (final endpoint in getEndpoints(session)) {
      // Crawl classes from all courses that the course unit is offered in
      final courseChoiceUrl = '$endpoint'
          'it_listagem.lista_cursos_disciplina?pv_ocorrencia_id=$occurrId';
      final courseChoiceResponse =
          await NetworkRouter.getWithCookies(courseChoiceUrl, {}, session);
      final courseChoiceDocument = parse(courseChoiceResponse.body);
      final urls = courseChoiceDocument
          .querySelectorAll('a')
          .where(
            (element) =>
                element.attributes['href'] != null &&
                element.attributes['href']!
                    .contains('it_listagem.lista_turma_disciplina'),
          )
          .map((e) {
        var url = e.attributes['href']!;
        if (!url.contains('sigarra.up.pt')) {
          url = endpoint + url;
        }
        return url;
      }).toList();

      for (final url in urls) {
        try {
          final response = await NetworkRouter.getWithCookies(url, {}, session);
          courseUnitClasses += parseCourseUnitClasses(response, endpoint);
        } catch (_) {
          continue;
        }
      }
    }

    return courseUnitClasses;
  }
}
