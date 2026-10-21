import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni/controller/fetchers/core/session_dependent_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_course_unit_info.dart';
import 'package:uni/controller/parsers/schedule/new_api/parser.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_statistics.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/session/flows/base/session.dart';

class CourseUnitsInfoFetcher implements SessionDependentFetcher {
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

  Future<List<Lecture>> fetchCourseUnitLectures(
    Session session,
    int occurId,
  ) async {
    final now = DateTime.now();
    final lectiveYear = now.month >= 8 ? now.year : now.year - 1;

    final baseUrls = NetworkRouter.getBaseUrlsFromSession(session);
    final url = '${baseUrls[0]}hor_geral.ucurr_view';

    try {
      final htmlResponse = await NetworkRouter.getWithCookies(url, {
        'pv_ocorrencia_id': occurId.toString(),
        'pv_ano_lectivo': lectiveYear.toString(),
        'pv_periodos': '1',
      }, session);

      final apiUrl = getScheduleApiUrlFromHtml(htmlResponse);
      if (apiUrl == null) {
        return [];
      }

      final apiResponse = await NetworkRouter.getWithCookies(
        apiUrl,
        {},
        session,
      );

      if (apiResponse.statusCode == 200) {
        final lectures =
            getUniqueLecturesFromApiResponse(apiResponse)
                .where(
                  (lecture) =>
                      lecture.endTime.isAfter(now) &&
                      lecture.startTime.isBefore(
                        now.add(const Duration(days: 14)),
                      ),
                )
                .toList()
              ..sort((a, b) => a.startTime.compareTo(b.startTime));
        return lectures;
      }
    } catch (err) {
      return [];
    }

    return [];
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
      final urls = courseChoiceDocument
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

  Future<Map<String, int>> fetchCourseUnitOccurences(
    Session session,
    int occurId,
  ) async {
    final url = '${getEndpoints(session)[0]}mob_ucurr_geral.outras_ocorrencias';

    try {
      final response = await NetworkRouter.getWithCookies(url, {
        'pv_ocorrencia_id': occurId.toString(),
      }, session);

      if (response.statusCode != 200) {
        return <String, int>{};
      }

      return parseOccurences(response);
    } catch (_) {
      return <String, int>{};
    }
  }

  Future<CourseUnitStatistics> fetchCourseUnitStatistics(
    Session session,
    int occurrId,
    String? schoolYear,
  ) async {
    final yearMatch = RegExp(r'^(\d{4})').firstMatch(schoolYear ?? '');
    final currentYear = yearMatch != null
        ? int.parse(yearMatch.group(1)!)
        : null;
    // If the requested year has no published results yet (e.g. a semester
    // that is about to start), fall back to the previous year. This mirrors
    // the website, which keeps the same occurrence id and only changes the
    // year parameter.
    final years = [currentYear, if (currentYear != null) currentYear - 1];

    final candidates = getEndpoints(session);

    CourseUnitStatistics? bestResult;

    for (final year in years) {
      final query = {
        'pv_ocorrencia_id': occurrId.toString(),
        if (year != null) 'pv_ano_letivo': year.toString(),
      };

      for (final base in candidates) {
        final url = '${base}est_geral.dist_result_ocorr';
        try {
          final response = await NetworkRouter.getWithCookies(
            url,
            query,
            session,
          );

          if (response.statusCode != 200) {
            continue;
          }

          final result = parseCourseUnitStatistics(response);
          bestResult ??= result;

          if (!result.isEvaluationEmpty) {
            // The page's <h2> shows the occurrence's own year, which can
            // differ from the requested year (e.g. when we fall back to the
            // previous year). Label the data with the year that was requested.
            final stat = year != null
                ? result.copyWith(schoolYear: '$year/${year + 1}')
                : result;
            return stat;
          }
        } catch (_) {
          // Fall through to the next candidate.
        }
      }
    }

    return bestResult ??
        const CourseUnitStatistics(
          schoolYear: '',
          enrolled: 0,
          approved: 0,
          failed: 0,
          notEvaluated: 0,
        );
  }
}
