import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/providers/bus_stop_provider.dart';
import 'package:uni/model/providers/calendar_provider.dart';
import 'package:uni/model/providers/exam_provider.dart';
import 'package:uni/model/providers/faculty_locations_provider.dart';
import 'package:uni/model/providers/favorite_cards_provider.dart';
import 'package:uni/model/providers/home_page_editing_mode_provider.dart';
import 'package:uni/model/providers/last_user_info_provider.dart';
import 'package:uni/model/providers/lecture_provider.dart';
import 'package:uni/model/providers/profile_state_provider.dart';
import 'package:uni/model/providers/public_transport_provider.dart';
import 'package:uni/model/providers/restaurant_provider.dart';
import 'package:uni/model/providers/session_provider.dart';
import 'package:uni/model/providers/user_faculties_provider.dart';

class StateProviders {
  final LectureProvider lectureProvider;
  final ExamProvider examProvider;
  final BusStopProvider busStopProvider;
  final RestaurantProvider restaurantProvider;
  final ProfileStateProvider profileStateProvider;
  final SessionProvider sessionProvider;
  final CalendarProvider calendarProvider;
  final FacultyLocationsProvider facultyLocationsProvider;
  final LastUserInfoProvider lastUserInfoProvider;
  final UserFacultiesProvider userFacultiesProvider;
  final FavoriteCardsProvider favoriteCardsProvider;
  final HomePageEditingMode homePageEditingMode;
  final PublicTransportationProvider publicTransportationProvider;

  StateProviders(
      this.lectureProvider,
      this.examProvider,
      this.busStopProvider,
      this.restaurantProvider,
      this.profileStateProvider,
      this.sessionProvider,
      this.calendarProvider,
      this.facultyLocationsProvider,
      this.lastUserInfoProvider,
      this.userFacultiesProvider,
      this.favoriteCardsProvider,
      this.homePageEditingMode,
      this.publicTransportationProvider);

  static StateProviders fromContext(BuildContext context) {
    final lectureProvider =
        Provider.of<LectureProvider>(context, listen: false);
    final examProvider = Provider.of<ExamProvider>(context, listen: false);
    final busStopProvider =
        Provider.of<BusStopProvider>(context, listen: false);
    final restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    final profileStateProvider =
        Provider.of<ProfileStateProvider>(context, listen: false);
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    final facultyLocationsProvider =
        Provider.of<FacultyLocationsProvider>(context, listen: false);
    final lastUserInfoProvider =
        Provider.of<LastUserInfoProvider>(context, listen: false);
    final userFacultiesProvider =
        Provider.of<UserFacultiesProvider>(context, listen: false);
    final favoriteCardsProvider =
        Provider.of<FavoriteCardsProvider>(context, listen: false);
    final homePageEditingMode =
        Provider.of<HomePageEditingMode>(context, listen: false);
    final publicTransportationProvider = 
        Provider.of<PublicTransportationProvider>(context, listen: false);


    return StateProviders(
        lectureProvider,
        examProvider,
        busStopProvider,
        restaurantProvider,
        profileStateProvider,
        sessionProvider,
        calendarProvider,
        facultyLocationsProvider,
        lastUserInfoProvider,
        userFacultiesProvider,
        favoriteCardsProvider,
        homePageEditingMode,
        publicTransportationProvider);
  }
}
