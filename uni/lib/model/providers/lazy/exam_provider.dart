import 'dart:async';

import 'package:uni/controller/fetchers/exam_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_exams_database.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

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
      persistentSession:
          (PreferencesController.getPersistentUserInfo()) != null,
    );
  }

  Future<List<Exam>> fetchUserExams(
    ParserExams parserExams,
    Profile profile,
    Session session,
    List<CourseUnit> userUcs, {
    required bool persistentSession,
  }) async {
    final exams = await ExamFetcher(profile.courses, userUcs)
        .extractExams(session, parserExams);

    exams.sort((exam1, exam2) => exam1.begin.compareTo(exam2.begin));

    if (persistentSession) {
      await AppExamsDatabase().saveNewExams(exams);
    }

    return exams;
  }

/*Future<void> updateFilteredExams() async {
    final exams = await AppSharedPreferences.getFilteredExams();
    _filteredExamsTypes = exams;
    notifyListeners();
  }

  Future<void> setFilteredExams(Map<String, bool> newFilteredExams) async {
    unawaited(AppSharedPreferences.saveFilteredExams(newFilteredExams));
    _filteredExamsTypes = Map<String, bool>.from(newFilteredExams);
    notifyListeners();
  }

  List<Exam> getFilteredExams() {
    return exams
        .where(
          (exam) => filteredExamsTypes[Exam.getExamTypeLong(exam.type)] ?? true,
        )
        .toList();
  }

  Future<void> setHiddenExams(List<String> newHiddenExams) async {
    _hiddenExams = List<String>.from(newHiddenExams);
    await AppSharedPreferences.saveHiddenExams(hiddenExams);
    notifyListeners();
  }

  Future<void> toggleHiddenExam(String newExamId) async {
    _hiddenExams.contains(newExamId)
        ? _hiddenExams.remove(newExamId)
        : _hiddenExams.add(newExamId);
    await AppSharedPreferences.saveHiddenExams(hiddenExams);
    notifyListeners();
  }*/
}
