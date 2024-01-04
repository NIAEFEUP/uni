import 'dart:collection';

import 'package:uni/controller/fetchers/course_units_fetcher/course_units_info_fetcher.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_directory.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class CourseUnitsInfoProvider extends StateProviderNotifier {
  CourseUnitsInfoProvider()
      : super(dependsOnSession: true, cacheDuration: null, initialize: false);
  final Map<CourseUnit, CourseUnitSheet> _courseUnitsSheets = {};
  final Map<CourseUnit, List<CourseUnitClass>> _courseUnitsClasses = {};
  final Map<CourseUnit, List<CourseUnitFileDirectory>> _courseUnitsFiles = {};

  UnmodifiableMapView<CourseUnit, CourseUnitSheet> get courseUnitsSheets =>
      UnmodifiableMapView(_courseUnitsSheets);

  UnmodifiableMapView<CourseUnit, List<CourseUnitClass>>
      get courseUnitsClasses => UnmodifiableMapView(_courseUnitsClasses);

  UnmodifiableMapView<CourseUnit, List<CourseUnitFileDirectory>>
      get courseUnitsFiles => UnmodifiableMapView(_courseUnitsFiles);

  Future<void> fetchCourseUnitSheet(
    CourseUnit courseUnit,
    Session session,
  ) async {
    _courseUnitsSheets[courseUnit] = await CourseUnitsInfoFetcher()
        .fetchCourseUnitSheet(session, courseUnit.occurrId);
  }

  Future<void> fetchCourseUnitClasses(
    CourseUnit courseUnit,
    Session session,
  ) async {
    _courseUnitsClasses[courseUnit] = await CourseUnitsInfoFetcher()
        .fetchCourseUnitClasses(session, courseUnit.occurrId);
  }

  Future<void> fetchCourseUnitFiles(
    CourseUnit courseUnit,
    Session session,
  ) async {
    _courseUnitsFiles[courseUnit] = await CourseUnitsInfoFetcher()
        .fetchCourseUnitFiles(session, courseUnit.occurrId);
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    // Course units info is loaded on demand by its detail page
  }

  @override
  Future<void> loadFromStorage() async {}
}
