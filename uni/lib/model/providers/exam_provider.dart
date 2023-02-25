import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/exam_fetcher.dart';
import 'package:uni/controller/local_storage/app_exams_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class ExamProvider extends StateProviderNotifier {
  List<Exam> _exams = [];
  Map<String, bool> _filteredExamsTypes = {};

  UnmodifiableListView<Exam> get exams => UnmodifiableListView(_exams);

  UnmodifiableMapView<String, bool> get filteredExamsTypes =>
      UnmodifiableMapView(_filteredExamsTypes);

  void getUserExams(
    Completer<void> action,
    ParserExams parserExams,
    Tuple2<String, String> userPersistentInfo,
    Profile profile,
    Session session,
    List<CourseUnit> userUcs,
  ) async {
    try {
      //need to get student course here
      updateStatus(RequestStatus.busy);

      final List<Exam> exams = await ExamFetcher(profile.courses, userUcs)
          .extractExams(session, parserExams);

      exams.sort((exam1, exam2) => exam1.begin.day.compareTo(exam2.begin.day));

      // Updates local database according to the information fetched -- Exams
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppExamsDatabase db = AppExamsDatabase();
        db.saveNewExams(exams);
      }

      _exams = exams;
      updateStatus(RequestStatus.successful);
      notifyListeners();
    } catch (e) {
      Logger().e('Failed to get Exams');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  updateStateBasedOnLocalUserExams() async {
    final AppExamsDatabase db = AppExamsDatabase();
    final List<Exam> exs = await db.exams();
    _exams = exs;
    notifyListeners();
  }

  updateFilteredExams() async {
    final exams = await AppSharedPreferences.getFilteredExams();
    _filteredExamsTypes = exams;
    notifyListeners();
  }

  setFilteredExams(
      Map<String, bool> newFilteredExams, Completer<void> action) async {
    _filteredExamsTypes = Map<String, bool>.from(newFilteredExams);
    AppSharedPreferences.saveFilteredExams(filteredExamsTypes);
    action.complete();
    notifyListeners();
  }

  List<Exam> getFilteredExams() {
    return exams
        .where((exam) =>
            filteredExamsTypes[Exam.getExamTypeLong(exam.type)] ?? true)
        .toList();
  }
}
