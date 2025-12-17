import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/course_units_info_fetcher.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher_new_api.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

typedef SheetsMap = Map<CourseUnit, Sheet>;
typedef ClassesMap = Map<CourseUnit, List<CourseUnitClass>>;
typedef FilesMap = Map<CourseUnit, List<CourseUnitFileDirectory>>;
typedef ClassProfessorsMap = Map<CourseUnit, Map<String, Professor>>;
typedef CourseUnitsInfoState =
    (SheetsMap, ClassesMap, FilesMap, ClassProfessorsMap);

final courseUnitsInfoProvider =
    AsyncNotifierProvider<CourseUnitsInfoNotifier, CourseUnitsInfoState?>(
      CourseUnitsInfoNotifier.new,
    );

class CourseUnitsInfoNotifier
    extends CachedAsyncNotifier<CourseUnitsInfoState?> {
  @override
  Duration? get cacheDuration => null;

  UnmodifiableMapView<CourseUnit, Sheet> get courseUnitsSheets {
    final currentState = state.value;
    return UnmodifiableMapView(currentState?.$1 ?? <CourseUnit, Sheet>{});
  }

  UnmodifiableMapView<CourseUnit, List<CourseUnitClass>>
  get courseUnitsClasses {
    final currentState = state.value;
    return UnmodifiableMapView(
      currentState?.$2 ?? <CourseUnit, List<CourseUnitClass>>{},
    );
  }

  UnmodifiableMapView<CourseUnit, List<CourseUnitFileDirectory>>
  get courseUnitsFiles {
    final currentState = state.value;
    return UnmodifiableMapView(
      currentState?.$3 ?? <CourseUnit, List<CourseUnitFileDirectory>>{},
    );
  }

  UnmodifiableMapView<CourseUnit, Map<String, Professor>>
  get courseUnitsClassProfessors {
    final currentState = state.value;
    return UnmodifiableMapView(
      currentState?.$4 ?? <CourseUnit, Map<String, Professor>>{},
    );
  }

  @override
  Future<CourseUnitsInfoState?> loadFromStorage() async {
    return (
      <CourseUnit, Sheet>{},
      <CourseUnit, List<CourseUnitClass>>{},
      <CourseUnit, List<CourseUnitFileDirectory>>{},
      <CourseUnit, Map<String, Professor>>{},
    );
  }

  @override
  Future<CourseUnitsInfoState?> loadFromRemote() async {
    return (
      <CourseUnit, Sheet>{},
      <CourseUnit, List<CourseUnitClass>>{},
      <CourseUnit, List<CourseUnitFileDirectory>>{},
      <CourseUnit, Map<String, Professor>>{},
    );
  }

  Future<void> fetchCourseUnitSheet(CourseUnit courseUnit) async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return;
    }

    final occurrId = courseUnit.occurrId;
    if (occurrId == null) {
      return;
    }

    final sheet = await CourseUnitsInfoFetcher().fetchSheet(session, occurrId);

    final currentState =
        state.value ??
        (
          <CourseUnit, Sheet>{},
          <CourseUnit, List<CourseUnitClass>>{},
          <CourseUnit, List<CourseUnitFileDirectory>>{},
          <CourseUnit, Map<String, Professor>>{},
        );

    final updatedSheetsMap = Map<CourseUnit, Sheet>.from(currentState.$1);
    updatedSheetsMap[courseUnit] = sheet;
    updateState((
      updatedSheetsMap,
      currentState.$2,
      currentState.$3,
      currentState.$4,
    ));
  }

  Future<void> fetchCourseUnitClasses(CourseUnit courseUnit) async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return;
    }

    final occurrId = courseUnit.occurrId;
    if (occurrId == null) {
      return;
    }

    final classes = await CourseUnitsInfoFetcher().fetchCourseUnitClasses(
      session,
      occurrId,
    );

    final currentState =
        state.value ??
        (
          <CourseUnit, Sheet>{},
          <CourseUnit, List<CourseUnitClass>>{},
          <CourseUnit, List<CourseUnitFileDirectory>>{},
          <CourseUnit, Map<String, Professor>>{},
        );

    final updatedClassesMap = Map<CourseUnit, List<CourseUnitClass>>.from(
      currentState.$2,
    );
    updatedClassesMap[courseUnit] = classes;
    updateState((
      currentState.$1,
      updatedClassesMap,
      currentState.$3,
      currentState.$4,
    ));
  }

  Future<void> fetchCourseUnitFiles(CourseUnit courseUnit) async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return;
    }

    final occurrId = courseUnit.occurrId;
    if (occurrId == null) {
      return;
    }

    final files = await CourseUnitsInfoFetcher().fetchCourseUnitFiles(
      session,
      occurrId,
    );

    final currentState =
        state.value ??
        (
          <CourseUnit, Sheet>{},
          <CourseUnit, List<CourseUnitClass>>{},
          <CourseUnit, List<CourseUnitFileDirectory>>{},
          <CourseUnit, Map<String, Professor>>{},
        );

    final updatedFilesMap = Map<CourseUnit, List<CourseUnitFileDirectory>>.from(
      currentState.$3,
    );
    updatedFilesMap[courseUnit] = files;
    updateState((
      currentState.$1,
      currentState.$2,
      updatedFilesMap,
      currentState.$4,
    ));
  }

  Future<void> fetchClassProfessors(CourseUnit courseUnit) async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return;
    }

    final sheet = courseUnitsSheets[courseUnit];
    if (sheet == null) {
      return;
    }

    final professors = sheet.professors;
    final Map<String, Professor> classProfessors = {};
    final courseAcronym = courseUnit.abbreviation;

    for (final professor in professors) {
      final fetcher = ScheduleFetcherNewApiProfessor(
        professorCode: professor.code,
      );
      final lectures = await fetcher.getLectures(session);

      for (final lecture in lectures) {
        if (lecture.classNumber.isNotEmpty &&
            lecture.acronym == courseAcronym) {
          classProfessors[lecture.classNumber] = professor;
        }
      }
    }

    final currentState =
        state.value ??
        (
          <CourseUnit, Sheet>{},
          <CourseUnit, List<CourseUnitClass>>{},
          <CourseUnit, List<CourseUnitFileDirectory>>{},
          <CourseUnit, Map<String, Professor>>{},
        );

    final updatedClassProfessorsMap =
        Map<CourseUnit, Map<String, Professor>>.from(currentState.$4);
    updatedClassProfessorsMap[courseUnit] = classProfessors;
    updateState((
      currentState.$1,
      currentState.$2,
      currentState.$3,
      updatedClassProfessorsMap,
    ));
  }
}
