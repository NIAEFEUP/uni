import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/bus_stop_provider.dart';
import 'package:uni/model/providers/calendar_provider.dart';
import 'package:uni/model/providers/exam_provider.dart';
import 'package:uni/model/providers/faculty_locations_provider.dart';
import 'package:uni/model/providers/home_page_provider.dart';
import 'package:uni/model/providers/lecture_provider.dart';
import 'package:uni/model/providers/library_occupation_provider.dart';
import 'package:uni/model/providers/profile_provider.dart';
import 'package:uni/model/providers/restaurant_provider.dart';
import 'package:uni/model/providers/session_provider.dart';

class StateProviders {
  final LectureProvider lectureProvider;
  final ExamProvider examProvider;
  final BusStopProvider busStopProvider;
  final RestaurantProvider restaurantProvider;
  final ProfileProvider profileStateProvider;
  final SessionProvider sessionProvider;
  final CalendarProvider calendarProvider;
  final LibraryOccupationProvider libraryOccupationProvider;
  final FacultyLocationsProvider facultyLocationsProvider;
  final HomePageProvider homePageProvider;

  StateProviders(
      this.lectureProvider,
      this.examProvider,
      this.busStopProvider,
      this.restaurantProvider,
      this.profileStateProvider,
      this.sessionProvider,
      this.calendarProvider,
      this.libraryOccupationProvider,
      this.facultyLocationsProvider,
      this.homePageProvider);

  static StateProviders fromContext(BuildContext context) {
    final lectureProvider =
        Provider.of<LectureProvider>(context, listen: false);
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    final busStopProvider =
        Provider.of<BusStopProvider>(context, listen: false);
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    final profileStateProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    final libraryOccupationProvider =
        Provider.of<LibraryOccupationProvider>(context, listen: false);
    final facultyLocationsProvider =
        Provider.of<FacultyLocationsProvider>(context, listen: false);
    final homePageProvider =
        Provider.of<HomePageProvider>(context, listen: false);

    return StateProviders(
        lectureProvider,
        examProvider,
        busStopProvider,
        restaurantProvider,
        profileStateProvider,
        sessionProvider,
        calendarProvider,
        libraryOccupationProvider,
        facultyLocationsProvider,
        homePageProvider);
  }
}
