import 'dart:async';
import 'dart:collection';

import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/exam_fetcher.dart';
import 'package:uni/controller/local_storage/app_exams_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class ExamProvider extends StateProviderNotifier {
  List<Exam> _exams = [];
  List<String> _hiddenExams = [];
  Map<String, bool> _filteredExamsTypes = {};

  ExamProvider()
      : super(dependsOnSession: true, cacheDuration: const Duration(days: 1));

  UnmodifiableListView<Exam> get exams => UnmodifiableListView(_exams);

  UnmodifiableListView<String> get hiddenExams =>
      UnmodifiableListView(_hiddenExams);

  UnmodifiableMapView<String, bool> get filteredExamsTypes =>
      UnmodifiableMapView(_filteredExamsTypes);

  @override
  Future<void> loadFromStorage() async {
    await setFilteredExams(await AppSharedPreferences.getFilteredExams());
    await setHiddenExams(await AppSharedPreferences.getHiddenExams());

    final AppExamsDatabase db = AppExamsDatabase();
    final List<Exam> exams = await db.exams();
    _exams = exams;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchUserExams(
        ParserExams(),
        await AppSharedPreferences.getPersistentUserInfo(),
        profile,
        session,
        profile.courseUnits);
  }

  Future<void> fetchUserExams(
    ParserExams parserExams,
    Tuple2<String, String> userPersistentInfo,
    Profile profile,
    Session session,
    List<CourseUnit> userUcs,
  ) async {
    try {
      final List<Exam> exams = await ExamFetcher(profile.courses, userUcs)
          .extractExams(session, parserExams);

      exams.sort((exam1, exam2) => exam1.begin.compareTo(exam2.begin));

      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppExamsDatabase db = AppExamsDatabase();
        db.saveNewExams(exams);
      }

      _exams = exams;
      updateStatus(RequestStatus.successful);
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }

  updateFilteredExams() async {
    final exams = await AppSharedPreferences.getFilteredExams();
    _filteredExamsTypes = exams;
    notifyListeners();
  }

  Future<void> setFilteredExams(Map<String, bool> newFilteredExams) async {
    AppSharedPreferences.saveFilteredExams(filteredExamsTypes);
    _filteredExamsTypes = Map<String, bool>.from(newFilteredExams);
    notifyListeners();
  }

  List<Exam> getFilteredExams() {
    return exams
        .where((exam) =>
            filteredExamsTypes[Exam.getExamTypeLong(exam.type)] ?? true)
        .toList();
  }

  setHiddenExams(List<String> newHiddenExams) async {
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
  }

  setExams(List<Exam> newExams) {
    _exams = newExams;
    notifyListeners();
  }
}
