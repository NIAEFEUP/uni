import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/model/entities/Lecture.dart';
import 'package:app_feup/model/entities/Session.dart';

// enum should be placed somewhere else?
enum RequestStatus { NONE, BUSY, FAILED, SUCCESSFUL }

class AppState {
  Map content = Map<String, dynamic>();

  Map getInitialContent() {
    return {
      "schedule": new List<Lecture>(),
      "exams": new List<Exam>(),
      "scheduleStatus": RequestStatus.NONE,
      "loginStatus": RequestStatus.NONE,
      "examsStatus": RequestStatus.NONE,
      "selected_page": "Área Pessoal",
      "session": new Session(authenticated: false),
      "busstops": new List<BusStop>(),
      "busstopStatus" : RequestStatus.NONE,
      "timeStamp" : new DateTime.now(),
      "currentTime" : new DateTime.now(),
      "profileStatus": RequestStatus.NONE,
      "printBalanceStatus": RequestStatus.NONE,
      "feesStatus": RequestStatus.NONE,
      "coursesStateStatus": RequestStatus.NONE,
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
