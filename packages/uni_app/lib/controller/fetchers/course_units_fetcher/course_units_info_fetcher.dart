import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_unit_info.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/session/flows/base/session.dart';

class CourseUnitsInfoFetcher implements SessionDependantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    return NetworkRouter.getBaseUrlsFromSession(session, languageSensitive: true).toList();
  }

  Future<Sheet> fetchSheet(
    Session session,
    int occurId,
  ) async {
    //TODO: Through this link we can't retrieve the sheet of a course unit in english
    final responses = await Future.wait(
      getEndpoints(session)
          .map(
            (endpoint) =>
                '$endpoint'
                'mob_ucurr_geral.perfil',
          )
          .map(
            (url) => NetworkRouter.getWithCookies(url, {
              'pv_ocorrencia_id': occurId.toString(),
            }, session).catchError((_) => Response('', 500)),
          ),
    );

    final bestResponse = responses
        .where((response) => response.statusCode == 200)
        .fold<Response?>(
          null,
          (best, current) =>
              current.body.length > (best?.body.length ?? 0) ? current : best,
        );

    return bestResponse != null
        ? parseSheet(bestResponse)
        : Sheet(
          professors: [],
          content: '',
          evaluation: '',
          frequency: '',
          books: [],
        );
  }

  Future<List<CourseUnitFileDirectory>> fetchCourseUnitFiles(
    Session session,
    int occurId,
  ) async {
    final url = '${getEndpoints(session)[0]}mob_ucurr_geral.conteudos';
    final response = await NetworkRouter.getWithCookies(url, {
      'pv_ocorrencia_id': occurId.toString(),
    }, session);
    return parseFiles(response, session);
  }

  Future<String> getDownloadLink(Session session) async {
    return '${getEndpoints(session)[0]}conteudos_service.conteudos_cont';
  }

  Future<List<CourseUnitClass>> fetchCourseUnitClasses(
    Session session,
    int occurrId,
  ) async {
    var courseUnitClasses = <CourseUnitClass>[];

    for (final endpoint in getEndpoints(session)) {
      // Crawl classes from all courses that the course unit is offered in
      final courseChoiceUrl =
          '$endpoint'
          'it_listagem.lista_cursos_disciplina?pv_ocorrencia_id=$occurrId';
      final courseChoiceResponse = await NetworkRouter.getWithCookies(
        courseChoiceUrl,
        {},
        session,
      );
      final courseChoiceDocument = parse(courseChoiceResponse.body);
      final urls =
          courseChoiceDocument
              .querySelectorAll('a')
              .where(
                (element) =>
                    element.attributes['href'] != null &&
                    element.attributes['href']!.contains(
                      'it_listagem.lista_turma_disciplina',
                    ),
              )
              .map((e) {
                var url = e.attributes['href']!;
                if (!url.contains('sigarra.up.pt')) {
                  url = endpoint + url;
                }
                return url;
              })
              .toList();

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
