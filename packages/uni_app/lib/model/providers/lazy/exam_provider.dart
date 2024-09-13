import 'dart:async';

import 'package:uni/controller/fetchers/exam_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_exams_database.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/session/flows/base/session.dart';

class ExamProvider extends StateProviderNotifier<List<Exam>> {
  ExamProvider() : super(cacheDuration: const Duration(days: 1));

  @override
  Future<List<Exam>> loadFromStorage(StateProviders stateProviders) async {
    final db = AppExamsDatabase();
    return db.exams();
  }

  @override
  Future<List<Exam>> loadFromRemote(StateProviders stateProviders) async {
    final session = stateProviders.sessionProvider.state!;
    final profile = stateProviders.profileProvider.state!;

    return fetchUserExams(
      ParserExams(),
      profile,
      session,
      profile.courseUnits,
    );
  }

  Future<List<Exam>> fetchUserExams(
    ParserExams parserExams,
    Profile profile,
    Session session,
    List<CourseUnit> userUcs,
  ) async {
    final exams = await ExamFetcher(profile.courses, userUcs)
        .extractExams(session, parserExams);

    exams.sort((exam1, exam2) => exam1.start.compareTo(exam2.start));

    final db = AppExamsDatabase();
    await db.saveIfPersistentSession(exams);
    return exams;
  }
}
