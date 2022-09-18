import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/session.dart';

class ExamFetcher implements SessionDependantFetcher {
  List<Course> courses;
  List<CourseUnit> userUcs;
  ExamFetcher(this.courses, this.userUcs);

  @override
  List<String> getEndpoints(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(session)
        .map((url) => '${url}exa_geral.mapa_de_exames')
        .toList();
    return urls;
  }

  Future<List<Exam>> extractExams(
      Session session, ParserExams parserExams) async {
    Set<Exam> courseExams = {};
    final urls = getEndpoints(session);
    for (Course course in courses) {
      for (final url in urls) {
        final Set<Exam> currentCourseExams = await parserExams.parseExams(
            await NetworkRouter.getWithCookies(
                url, {'p_curso_id': course.id.toString()}, session));
        courseExams = Set.from(courseExams)..addAll(currentCourseExams);
      }
    }

    final Set<Exam> exams = {};
    for (Exam courseExam in courseExams) {
      for (CourseUnit uc in userUcs) {
        if (!courseExam.examType.contains(
                '''Exames ao abrigo de estatutos especiais - Port.Est.Especiais''') &&
            courseExam.examType != 'EE' &&
            courseExam.examType != 'EAE' &&
            courseExam.subject == uc.abbreviation &&
            !courseExam.hasEnded()) {
          exams.add(courseExam);
          break;
        }
      }
    }

    return exams.toList();
  }
}
