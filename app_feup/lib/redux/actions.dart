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

class SetExamsStatusAction{
  bool busy;
  SetExamsStatusAction(this.busy);
}

class SetScheduleAction{
  List<Lecture> lectures;
  SetScheduleAction(this.lectures);
}

class SetScheduleStatusAction{
  bool busy;
  SetScheduleStatusAction(this.busy);
}

class UpdateSelectedPageAction {
    String selected_page;
    UpdateSelectedPageAction(this.selected_page);
}

class SetPrintBalanceAction {
  String printBalance;
  SetPrintBalanceAction(this.printBalance);
}

class SetFeesBalanceAction {
  String feesBalance;
  SetFeesBalanceAction(this.feesBalance);
}