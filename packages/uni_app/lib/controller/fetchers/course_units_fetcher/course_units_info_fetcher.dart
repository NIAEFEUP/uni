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
    return NetworkRouter.getBaseUrlsFromSession(
      session,
      languageSensitive: true,
    ).toList();
  }

  Future<Sheet> fetchSheet(Session session, int occurId) async {
    // TODO: Through this link we can't retrieve the sheet of a course unit in english
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
    final endpoints = getEndpoints(session);
    final allCourseChoices = await Future.wait(
      endpoints.map((endpoint) {
        final url = '$endpoint'
            'it_listagem.lista_cursos_disciplina?pv_ocorrencia_id=$occurrId';
        return NetworkRouter.getWithCookies(url, {}, session)
            .then((res) => (endpoint, res))
            .catchError((_) => (endpoint, Response('', 500)));
      }),
    );

    final classUrls = <(String, String)>{};
    for (final (endpoint, response) in allCourseChoices) {
      if (response.statusCode != 200) {
        continue;
      }
      
      final document = parse(response.body);
      final links = document.querySelectorAll('a').where((e) =>
          e.attributes['href']?.contains('it_listagem.lista_turma_disciplina') ?? false);
      
      for (final link in links) {
        var url = link.attributes['href']!;
        if (!url.contains('sigarra.up.pt')) {
          url = endpoint + url;
        }
        classUrls.add((endpoint, url));
      }
    }

    final classResponses = await Future.wait(
      classUrls.map((item) => 
        NetworkRouter.getWithCookies(item.$2, {}, session)
            .then((res) => (item.$1, res))
            .catchError((_) => (item.$1, Response('', 500)))
      )
    );

    final Map<String, CourseUnitClass> classesByName = {};
    for (final (endpoint, response) in classResponses) {
      if (response.statusCode != 200) {
        continue;
      }
      final parsedClasses = parseCourseUnitClasses(response, endpoint);
      for (final c in parsedClasses) {
        classesByName[c.className] = c;
      }
    }

    return classesByName.values.toList();
  }
}
