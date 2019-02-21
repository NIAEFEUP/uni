import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/model/LoginPageModel.dart';

class SaveLoginDataAction {
  Map<String, dynamic> session;
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