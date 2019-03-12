import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/model/AppState.dart';

class SaveLoginDataAction {
  Map<String, dynamic> session;
  SaveLoginDataAction(this.session);
}

class SetLoginStatusAction {
  RequestStatus status;
  SetLoginStatusAction(this.status);
}

class SetExamsAction{
  List<Exam> exams;
  SetExamsAction(this.exams);
}

class SetExamsStatusAction{
  RequestStatus status;
  SetExamsStatusAction(this.status);
}

class SetScheduleAction{
  List<Lecture> lectures;
  SetScheduleAction(this.lectures);
}

class SetScheduleStatusAction{
  RequestStatus status;
  SetScheduleStatusAction(this.status);
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