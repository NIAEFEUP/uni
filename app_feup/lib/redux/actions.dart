import 'package:app_feup/controller/parsers/parser-exams.dart';

class SaveLoginDataAction {
  String cookies;
  SaveLoginDataAction(this.cookies);
}

class SetExamsAction{
  List<Exam> exams;
  SetExamsAction(this.exams);
}

class UpdateSelectedPageAction {
    String selected_page;
    UpdateSelectedPageAction(this.selected_page);
}