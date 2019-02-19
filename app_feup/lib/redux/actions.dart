import 'package:app_feup/controller/parsers/parser-exams.dart';

class SaveLoginDataAction {
  String cookies;
  SaveLoginDataAction(this.cookies);
}

class SetExamsAction{
  List<Exam> exams;
  SetExamsAction(this.exams);
}