import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/model/LoginPageModel.dart';
import 'package:app_feup/model/entities/Session.dart';

class SaveLoginDataAction {
  Session session;
  SaveLoginDataAction(this.session);
}

class SetLoginStatusAction {
  LoginStatus status;
  SetLoginStatusAction(this.status);
}

class SetExamsAction{
  List<Exam> exams;
  SetExamsAction(this.exams);
}

class SetScheduleAction{
  List<Lecture> lectures;
  SetScheduleAction(this.lectures);
}

class UpdateSelectedPageAction {
  String selected_page;
  UpdateSelectedPageAction(this.selected_page);
}

class SaveProfileAction {
  Map<String, dynamic> profile;
  SaveProfileAction(this.profile);
}

class SaveUcsAction {
  Map<String, dynamic> ucs;
  SaveUcsAction(this.ucs);
}