import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/session/flows/base/session.dart';

class ExamFetcher implements SessionDependantFetcher {
  ExamFetcher(this.courses, this.userUcs);
  List<Course> courses;
  List<CourseUnit> userUcs;

  @override
  List<String> getEndpoints(Session session) {
    final urls = NetworkRouter.getBaseUrlsFromSession(session)
        .map((url) => '${url}exa_geral.mapa_de_exames')
        .toList();
    return urls;
  }

  Future<List<Exam>> extractExams(
    Session session,
    ParserExams parserExams,
  ) async {
    var courseExams = <Exam>{};
    final urls = getEndpoints(session);
    for (final course in courses) {
      for (final url in urls) {
        final currentCourseExams = await parserExams.parseExams(
          await NetworkRouter.getWithCookies(
            url,
            {'p_curso_id': course.id.toString()},
            session,
          ),
          course,
        );
        courseExams = Set.from(courseExams)..addAll(currentCourseExams);
      }
    }

    final exams = <Exam>{};
    for (final courseExam in courseExams) {
      for (final uc in userUcs) {
        if (!courseExam.examType.contains(
              '''Exames ao abrigo de estatutos especiais - Port.Est.Especiais''',
            ) &&
            courseExam.examType != 'EE' &&
            courseExam.examType != 'EAE' &&
            courseExam.subject == uc.abbreviation &&
            uc.enrollmentIsValid() &&
            !courseExam.hasEnded()) {
          exams.add(courseExam);
          break;
        }
      }
    }
    return exams.toList();
  }
}
