import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/model/HomePageModel.dart';
import 'package:app_feup/model/LoginPageModel.dart';
import 'package:app_feup/model/entities/CourseUnit.dart';
import 'package:app_feup/model/entities/Profile.dart';
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
  Profile profile;
  SaveProfileAction(this.profile);
}

class SaveUcsAction {
  List<CourseUnit> ucs;
  SaveUcsAction(this.ucs);
}

class SetPrintBalanceAction {
  String printBalance;
  SetPrintBalanceAction(this.printBalance);
}

class SetFeesBalanceAction {
  String feesBalance;
  SetFeesBalanceAction(this.feesBalance);
}

class UpdateFavoriteCards {
  List<FAVORITE_WIDGET_TYPE> favoriteCards;
  UpdateFavoriteCards(this.favoriteCards);
}