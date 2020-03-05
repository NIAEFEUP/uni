
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
      "schedule": new List<Lecture>(),
      "exams": new List<Exam>(),
      "scheduleStatus": RequestStatus.none,
      "loginStatus": RequestStatus.none,
      "examsStatus": RequestStatus.none,
      "selected_page": "Área Pessoal",
      "session": new Session(authenticated: false),
      "configuredBusStops": new Map<String, BusStopData>(),
      "currentBusTrips": new Map<String, List<Trip>>(),
      "busstopStatus" : RequestStatus.none,
      "timeStamp" : new DateTime.now(),
      "currentTime" : new DateTime.now(),
      "profileStatus": RequestStatus.none,
      "printBalanceStatus": RequestStatus.none,
      "feesStatus": RequestStatus.none,
      "coursesStateStatus": RequestStatus.none,
      "session": new Session(authenticated: false),
      "lastUserInfoUpdateTime": null
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
    return new AppState(Map.from(this.content)..[key] = value);
  }

  AppState getInitialState() {
    return new AppState(null);
  }
}
