import 'dart:collection';

import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/course_units_fetcher/course_units_info_fetcher.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

typedef SheetsMap = Map<CourseUnit, CourseUnitSheet>;
typedef ClassesMap = Map<CourseUnit, List<CourseUnitClass>>;

class CourseUnitsInfoProvider
    extends StateProviderNotifier<Tuple2<SheetsMap, ClassesMap>> {
  CourseUnitsInfoProvider() : super(cacheDuration: null);

  UnmodifiableMapView<CourseUnit, CourseUnitSheet> get courseUnitsSheets =>
      UnmodifiableMapView(state!.item1);

  UnmodifiableMapView<CourseUnit, List<CourseUnitClass>>
      get courseUnitsClasses => UnmodifiableMapView(state!.item2);

  Future<void> fetchCourseUnitSheet(
    CourseUnit courseUnit,
    Session session,
  ) async {
    state!.item1[courseUnit] = await CourseUnitsInfoFetcher()
        .fetchCourseUnitSheet(session, courseUnit.occurrId);
    notifyListeners();
  }

  Future<void> fetchCourseUnitClasses(
    CourseUnit courseUnit,
    Session session,
  ) async {
    state!.item2[courseUnit] = await CourseUnitsInfoFetcher()
        .fetchCourseUnitClasses(session, courseUnit.occurrId);
  }

  @override
  Future<Tuple2<SheetsMap, ClassesMap>> loadFromRemote(
    Session session,
    Profile profile,
  ) async {
    return const Tuple2({}, {});
  }

  @override
  Future<Tuple2<SheetsMap, ClassesMap>> loadFromStorage() async {
    return const Tuple2({}, {});
  }
}
