import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/library_occupation.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/utils/favorite_widget_type.dart';

class SaveLoginDataAction {
  Session session;
  SaveLoginDataAction(this.session);
}

class SetLoginStatusAction {
  RequestStatus status;
  SetLoginStatusAction(this.status);
}

class SetExamsAction {
  List<Exam> exams;
  SetExamsAction(this.exams);
}

class SetExamsStatusAction {
  RequestStatus status;
  SetExamsStatusAction(this.status);
}

class SetCalendarAction {
  List<CalendarEvent> calendar;
  SetCalendarAction(this.calendar);
}

class SetCalendarStatusAction {
  RequestStatus status;
  SetCalendarStatusAction(this.status);
}

class SetLibraryOccupationAction {
  LibraryOccupation occupation;
  SetLibraryOccupationAction(this.occupation);
}

class SetLibraryOccupationStatusAction {
  RequestStatus status;
  SetLibraryOccupationStatusAction(this.status);
}

class SetRestaurantsAction {
  List<Restaurant> restaurants;
  SetRestaurantsAction(this.restaurants);
}

class SetRestaurantsStatusAction {
  RequestStatus status;
  SetRestaurantsStatusAction(this.status);
}

class SetScheduleAction {
  List<Lecture> lectures;
  SetScheduleAction(this.lectures);
}

class SetScheduleStatusAction {
  RequestStatus status;
  SetScheduleStatusAction(this.status);
}

class SetInitialStoreStateAction {
  SetInitialStoreStateAction();
}

class SaveProfileAction {
  Profile profile;
  SaveProfileAction(this.profile);
}

class SaveProfileStatusAction {
  RequestStatus status;
  SaveProfileStatusAction(this.status);
}

class SaveCurrentUcsAction {
  List<CourseUnit> currUcs;
  SaveCurrentUcsAction(this.currUcs);
}

class SaveAllUcsAction {
  List<CourseUnit> allUcs;
  SaveAllUcsAction(this.allUcs);
}

class SaveAllUcsActionStatus {
  RequestStatus status;
  SaveAllUcsActionStatus(this.status);
}

class SetPrintBalanceAction {
  String printBalance;
  SetPrintBalanceAction(this.printBalance);
}

class SetPrintBalanceStatusAction {
  RequestStatus status;
  SetPrintBalanceStatusAction(this.status);
}

class SetFeesBalanceAction {
  String feesBalance;
  SetFeesBalanceAction(this.feesBalance);
}

class SetFeesLimitAction {
  String feesLimit;
  SetFeesLimitAction(this.feesLimit);
}

class SetFeesStatusAction {
  RequestStatus status;
  SetFeesStatusAction(this.status);
}

class SetBusTripsAction {
  Map<String, List<Trip>> trips;
  SetBusTripsAction(this.trips);
}

class SetBusStopsAction {
  Map<String, BusStopData> busStops;
  SetBusStopsAction(this.busStops);
}

class SetBusTripsStatusAction {
  RequestStatus status;
  SetBusTripsStatusAction(this.status);
}

class SetBusStopTimeStampAction {
  DateTime timeStamp;
  SetBusStopTimeStampAction(this.timeStamp);
}

class UpdateFavoriteCards {
  List<FavoriteWidgetType> favoriteCards;
  UpdateFavoriteCards(this.favoriteCards);
}

class SetPrintRefreshTimeAction {
  String? time;
  SetPrintRefreshTimeAction(this.time);
}

class SetFeesRefreshTimeAction {
  String? time;
  SetFeesRefreshTimeAction(this.time);
}

class SetHomePageEditingMode {
  bool state;
  SetHomePageEditingMode(this.state);
}

class SetLastUserInfoUpdateTime {
  DateTime currentTime;
  SetLastUserInfoUpdateTime(this.currentTime);
}

class SetExamFilter {
  Map<String, bool> filteredExams;
  SetExamFilter(this.filteredExams);
}

class SetLocationsAction {
  List<LocationGroup> locationGroups;
  SetLocationsAction(this.locationGroups);
}

class SetLocationsStatusAction {
  RequestStatus status;
  SetLocationsStatusAction(this.status);
}

class SetUserFaculties {
  List<String> faculties;
  SetUserFaculties(this.faculties);
}
