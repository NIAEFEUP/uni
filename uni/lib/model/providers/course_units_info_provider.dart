import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/course_units_info_fetcher.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class CourseUnitsInfoProvider extends StateProviderNotifier {
  final Map<CourseUnit, CourseUnitSheet> _courseUnitsSheets = {};
  final Map<CourseUnit, List<CourseUnitClass>> _courseUnitsClasses = {};

  UnmodifiableMapView<CourseUnit, CourseUnitSheet> get courseUnitsSheets =>
      UnmodifiableMapView(_courseUnitsSheets);
  UnmodifiableMapView<CourseUnit, List<CourseUnitClass>>
      get courseUnitsClasses => UnmodifiableMapView(_courseUnitsClasses);

  getCourseUnitSheet(CourseUnit courseUnit, Session session) async {
    updateStatus(RequestStatus.busy);
    try {
      _courseUnitsSheets[courseUnit] = await CourseUnitsInfoFetcher()
          .fetchCourseUnitSheet(session, courseUnit.occurrId);
    } catch (e) {
      updateStatus(RequestStatus.failed);
      Logger().e('Failed to get course unit sheet for ${courseUnit.name}: $e');
      return;
    }
    updateStatus(RequestStatus.successful);
  }

  getCourseUnitClasses(CourseUnit courseUnit, Session session) async {
    updateStatus(RequestStatus.busy);
    try {
      _courseUnitsClasses[courseUnit] = await CourseUnitsInfoFetcher()
          .fetchCourseUnitClasses(session, courseUnit.occurrId);
    } catch (e) {
      updateStatus(RequestStatus.failed);
      Logger()
          .e('Failed to get course unit classes for ${courseUnit.name}: $e');
      return;
    }
    updateStatus(RequestStatus.successful);
  }
}
