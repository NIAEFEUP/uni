import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/utils/constants.dart' as constants;

enum RequestStatus { none, busy, failed, successful }

class AppState {
  Map content = <String, dynamic>{};

  Map getInitialContent() {
    return {
      'schedule': <Lecture>[],
      'exams': <Exam>[],
      'restaurants': <Restaurant>[],
      'filteredExam': <String, bool>{},
      'scheduleStatus': RequestStatus.none,
      'loginStatus': RequestStatus.none,
      'examsStatus': RequestStatus.none,
      'selected_page': constants.navPersonalArea,
      'session': Session(
          authenticated: false,
          type: '',
          cookies: '',
          faculties: ['feup'], // TODO: Why does this need to be here?
          studentNumber: '',
          persistentSession: false),
      'configuredBusStops': <String, BusStopData>{},
      'currentBusTrips': <String, List<Trip>>{},
      'busStopStatus': RequestStatus.none,
      'timeStamp': DateTime.now(),
      'currentTime': DateTime.now(),
      'profileStatus': RequestStatus.none,
      'printBalanceStatus': RequestStatus.none,
      'feesStatus': RequestStatus.none,
      'lastUserInfoUpdateTime': null,
      'locationGroups': <LocationGroup>[],
    };
  }

  AppState(Map? content) {
    this.content = content ?? getInitialContent();
  }

  AppState cloneAndUpdateValue(key, value) {
    return AppState(Map.from(content)..[key] = value);
  }

  AppState getInitialState() {
    return AppState(null);
  }
}
