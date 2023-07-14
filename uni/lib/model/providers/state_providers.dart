import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/lazy/bus_stop_provider.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/model/providers/lazy/home_page_provider.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/providers/lazy/library_occupation_provider.dart';
import 'package:uni/model/providers/lazy/reference_provider.dart';
import 'package:uni/model/providers/lazy/restaurant_provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/providers/lazy/public_transport_provider.dart';


class StateProviders {
  final LectureProvider lectureProvider;
  final ExamProvider examProvider;
  final RestaurantProvider restaurantProvider;
  final ProfileProvider profileStateProvider;
  final SessionProvider sessionProvider;
  final CalendarProvider calendarProvider;
  final LibraryOccupationProvider libraryOccupationProvider;
  final FacultyLocationsProvider facultyLocationsProvider;
  final PublicTransportationProvider publicTransportationProvider;
  final HomePageProvider homePageProvider;
  final ReferenceProvider referenceProvider;
  final BusStopProvider busStopProvider;

  StateProviders(
      this.lectureProvider,
      this.examProvider,
      this.restaurantProvider,
      this.profileStateProvider,
      this.sessionProvider,
      this.calendarProvider,
      this.libraryOccupationProvider,
      this.facultyLocationsProvider,
      this.homePageProvider,
      this.referenceProvider,
      this.publicTransportationProvider, 
      this.busStopProvider);

  static StateProviders fromContext(BuildContext context) {
    final lectureProvider =
        Provider.of<LectureProvider>(context, listen: false);
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
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
    final referenceProvider =
        Provider.of<ReferenceProvider>(context, listen: false);
    final publicTransportationProvider = 
        Provider.of<PublicTransportationProvider>(context, listen: false);
    final busStopProvider = Provider.of<BusStopProvider>(context, listen: false);

    return StateProviders(
        lectureProvider,
        examProvider,
        restaurantProvider,
        profileStateProvider,
        sessionProvider,
        calendarProvider,
        libraryOccupationProvider,
        facultyLocationsProvider,
        homePageProvider,
        referenceProvider,
        publicTransportationProvider,
        busStopProvider);
  }
}
