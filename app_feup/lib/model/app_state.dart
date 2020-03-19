
// enum should be placed somewhere else?
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';

import 'entities/exam.dart';
import 'entities/lecture.dart';

enum RequestStatus { none, busy, failed, successful }

class AppState {
  Map content = Map<String, dynamic>();

  Map getInitialContent() {
    return {
      'schedule':  List<Lecture>(),
      'exams':  List<Exam>(),
      'scheduleStatus': RequestStatus.none,
      'loginStatus': RequestStatus.none,
      'examsStatus': RequestStatus.none,
      'selected_page': 'Área Pessoal',
      'session':  Session(authenticated: false),
      'configuredBusStops':  Map<String, BusStopData>(),
      'currentBusTrips':  Map<String, List<Trip>>(),
      'busstopStatus' : RequestStatus.none,
      'timeStamp' :  DateTime.now(),
      'currentTime' :  DateTime.now(),
      'profileStatus': RequestStatus.none,
      'printBalanceStatus': RequestStatus.none,
      'feesStatus': RequestStatus.none,
      'coursesStateStatus': RequestStatus.none,
      'session':  Session(authenticated: false),
      'lastUserInfoUpdateTime': null
    };
  }

  AppState(Map content) {
    if (content != null) {
      this.content = content;
    } else {
      this.content = this.getInitialContent();
    }
  }

  AppState cloneAndUpdateValue(key, value) {
    return  AppState(Map.from(this.content)..[key] = value);
  }

  AppState getInitialState() {
    return  AppState(null);
  }
}
