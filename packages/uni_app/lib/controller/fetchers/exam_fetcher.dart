import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/session/flows/base/session.dart';

class ExamFetcher implements SessionDependantFetcher {
  ExamFetcher(this.userUcs);
  List<CourseUnit> userUcs;

  @override
  List<String> getEndpoints(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(
      session,
    ).map((url) => '${url}exa_geral.mapa_de_exames').toList();
    return urls;
  }

  Future<List<Exam>> extractExams(Session session) async {
    final parserExams = ParserExams();
    final urls = getEndpoints(session);

    final futures = userUcs.expand<Future<Set<Exam>>>(
      (uc) => urls.map((url) async {
        final response = await NetworkRouter.getWithCookies(url, {
          'p_ocorr_id': uc.occurrId.toString(),
        }, session);
        return parserExams.parseExams(response, uc);
      }),
    );

    final results = await Future.wait(futures);
    final courseExams = results.expand((i) => i).toSet();

    final exams = <Exam>{};
    for (final courseExam in courseExams) {
      for (final uc in userUcs) {
        if (!uc.enrollmentIsValid()) {
          continue;
        }
        if (courseExam.hasEnded()) {
          continue;
        }
        exams.add(courseExam);
        break;
      }
    }
    return exams.toList();
  }
}
