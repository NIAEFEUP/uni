import 'package:app_feup/model/LoginPageModel.dart';

class SaveLoginDataAction {
  Map<String, dynamic> session;
  SaveLoginDataAction(this.session);
}

class SetLoginStatusAction {
  LoginStatus status;
  SetLoginStatusAction(this.status);
}