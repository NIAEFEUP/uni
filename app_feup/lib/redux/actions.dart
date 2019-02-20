import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';

class SaveLoginDataAction {
  String cookies;
  SaveLoginDataAction(this.cookies);
}

class SetExamsAction{
  List<Exam> exams;
  SetExamsAction(this.exams);
}

class SetScheduleAction{
  List<Lecture> lectures;
  SetScheduleAction(this.lectures);
}