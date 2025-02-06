import 'dart:collection';

import 'package:uni/controller/fetchers/course_units_fetcher/course_units_info_fetcher.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/sheet.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';
import 'package:uni/session/flows/base/session.dart';

typedef SheetsMap = Map<CourseUnit, Sheet>;
typedef ClassesMap = Map<CourseUnit, List<CourseUnitClass>>;
typedef FilesMap = Map<CourseUnit, List<CourseUnitFileDirectory>>;

class CourseUnitsInfoProvider
    extends StateProviderNotifier<(SheetsMap, ClassesMap, FilesMap)> {
  CourseUnitsInfoProvider()
      : super(
          cacheDuration: null,
          // Const constructor is not allowed here because of the
          // need for mutable maps
          // ignore: prefer_const_constructors
          initialState: ({}, {}, {}),
        );

  UnmodifiableMapView<CourseUnit, Sheet> get courseUnitsSheets =>
      UnmodifiableMapView(state!.$1);

  UnmodifiableMapView<CourseUnit, List<CourseUnitClass>>
      get courseUnitsClasses => UnmodifiableMapView(state!.$2);

  UnmodifiableMapView<CourseUnit, List<CourseUnitFileDirectory>>
      get courseUnitsFiles => UnmodifiableMapView(state!.$3);

  Future<void> fetchCourseUnitSheet(
    CourseUnit courseUnit,
    Session session,
  ) async {
    final occurrId = courseUnit.occurrId;
    if (occurrId == null) {
      return;
    }

    state!.$1[courseUnit] =
        await CourseUnitsInfoFetcher().fetchSheet(session, occurrId);
  }

  Future<void> fetchCourseUnitClasses(
    CourseUnit courseUnit,
    Session session,
  ) async {
    final occurrId = courseUnit.occurrId;
    if (occurrId == null) {
      return;
    }

    state!.$2[courseUnit] = await CourseUnitsInfoFetcher()
        .fetchCourseUnitClasses(session, occurrId);
    notifyListeners();
  }

  Future<void> fetchCourseUnitFiles(
    CourseUnit courseUnit,
    Session session,
  ) async {
    final occurrId = courseUnit.occurrId;
    if (occurrId == null) {
      return;
    }

    state!.$3[courseUnit] =
        await CourseUnitsInfoFetcher().fetchCourseUnitFiles(session, occurrId);
    notifyListeners();
  }

  @override
  Future<(SheetsMap, ClassesMap, FilesMap)> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    return (
      <CourseUnit, Sheet>{},
      <CourseUnit, List<CourseUnitClass>>{},
      <CourseUnit, List<CourseUnitFileDirectory>>{}
    );
  }

  @override
  Future<(SheetsMap, ClassesMap, FilesMap)> loadFromStorage(
    StateProviders stateProviders,
  ) async {
    return (
      <CourseUnit, Sheet>{},
      <CourseUnit, List<CourseUnitClass>>{},
      <CourseUnit, List<CourseUnitFileDirectory>>{}
    );
  }
}
