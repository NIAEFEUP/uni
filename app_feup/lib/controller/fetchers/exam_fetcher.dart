import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/model/entities/session.dart';

import '../../model/entities/course.dart';
import '../../model/entities/course_unit.dart';
import '../../model/entities/exam.dart';
import '../networking/network_router.dart';
import '../parsers/parser_exams.dart';

class ExamFetcher implements SessionDependantFetcher {
  List<Course> courses;
  List<CourseUnit> userUcs;
  ExamFetcher(this.courses, this.userUcs);

  @override
  List<String> getEndpoints(Session session) {
    // TODO: implement getEndpoints
    throw UnimplementedError();
  }

  Future<List<Exam>> extractExams(
      Session session, ParserExams parserExams) async {
    Set<Exam> courseExams = Set();
    for (Course course in courses) {
      final Set<Exam> currentCourseExams = await parserExams.parseExams(
          await NetworkRouter.getWithCookies(
              NetworkRouter.getBaseUrlsFromSession(session)[0] +
                  'exa_geral.mapa_de_exames?p_curso_id=${course.id}',
              {},
              session));
      courseExams = Set.from(courseExams)..addAll(currentCourseExams);
    }

    final Set<Exam> exams = Set();
    for (Exam courseExam in courseExams) {
      for (CourseUnit uc in userUcs) {
        if (!courseExam.examType.contains(
                '''Exames ao abrigo de estatutos especiais - Port.Est.Especiais''') &&
            courseExam.subject == uc.abbreviation &&
            courseExam.hasEnded()) {
          exams.add(courseExam);
          break;
        }
      }
    }

    return exams.toList();
  }
}
