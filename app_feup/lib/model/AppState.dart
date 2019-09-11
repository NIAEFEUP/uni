import 'package:app_feup/model/entities/Session.dart';

// enum should be placed somewhere else?
enum RequestStatus {
  NONE, BUSY, FAILED, SUCCESSFUL
}

class AppState {

  Map content = Map<String, dynamic>();

  Map getInitialContent() {
    return {
      "schedule": [],
      "exams": [],
      "scheduleStatus": RequestStatus.NONE,
      "examsStatus": RequestStatus.NONE,
      "profileStatus": RequestStatus.NONE,
      "printBalanceStatus": RequestStatus.NONE,
      "feesStatus": RequestStatus.NONE,
      "coursesStateStatus": RequestStatus.NONE,
      "selected_page": "Área Pessoal",
      "session": new Session(authenticated: false),
    };
  }

  AppState(Map content) {
    if (content != null) {
      this.content = content;
    } else {
      this.content = this.getInitialContent();
    }
  }

  AppState cloneAndUpdateValue(key, value){
    return new AppState(
        Map.from(this.content)
          ..[key] = value);
  }

}