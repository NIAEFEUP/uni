import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/model/providers/lazy/course_units_info_provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/model/providers/lazy/reference_provider.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';

class StateProviders {
  StateProviders(
    this.lectureProvider,
    this.examProvider,
    this.busStopProvider,
    this.restaurantProvider,
    this.profileProvider,
    this.courseUnitsInfoProvider,
    this.sessionProvider,
    this.calendarProvider,
    this.libraryOccupationProvider,
    this.facultyLocationsProvider,
    this.referenceProvider,
  );

  factory StateProviders.fromContext(BuildContext context) {
    // In tests, one does not initialize all providers
    // but a version of them is needed for the load methods.
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return StateProviders(
        LectureProvider(),
        ExamProvider(),
        BusStopProvider(),
        RestaurantProvider(),
        ProfileProvider(),
        CourseUnitsInfoProvider(),
        SessionProvider(),
        CalendarProvider(),
        LibraryOccupationProvider(),
        FacultyLocationsProvider(),
        ReferenceProvider(),
      );
    }

    final lectureProvider =
        Provider.of<LectureProvider>(context, listen: false);
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    final busStopProvider =
        Provider.of<BusStopProvider>(context, listen: false);
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    final courseUnitsInfoProvider =
        Provider.of<CourseUnitsInfoProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    final libraryOccupationProvider =
        Provider.of<LibraryOccupationProvider>(context, listen: false);
    final facultyLocationsProvider =
        Provider.of<FacultyLocationsProvider>(context, listen: false);
    final referenceProvider =
        Provider.of<ReferenceProvider>(context, listen: false);

    return StateProviders(
      lectureProvider,
      examProvider,
      busStopProvider,
      restaurantProvider,
      profileProvider,
      courseUnitsInfoProvider,
      sessionProvider,
      calendarProvider,
      libraryOccupationProvider,
      facultyLocationsProvider,
      referenceProvider,
    );
  }

  final LectureProvider lectureProvider;
  final ExamProvider examProvider;
  final BusStopProvider busStopProvider;
  final RestaurantProvider restaurantProvider;
  final CourseUnitsInfoProvider courseUnitsInfoProvider;
  final ProfileProvider profileProvider;
  final SessionProvider sessionProvider;
  final CalendarProvider calendarProvider;
  final LibraryOccupationProvider libraryOccupationProvider;
  final FacultyLocationsProvider facultyLocationsProvider;
  final ReferenceProvider referenceProvider;

  void invalidate() {
    lectureProvider.invalidate();
    examProvider.invalidate();
    busStopProvider.invalidate();
    restaurantProvider.invalidate();
    courseUnitsInfoProvider.invalidate();
    profileProvider.invalidate();
    sessionProvider.invalidate();
    calendarProvider.invalidate();
    libraryOccupationProvider.invalidate();
    facultyLocationsProvider.invalidate();
    referenceProvider.invalidate();
  }
}
