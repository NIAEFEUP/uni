import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';

class Session {
  bool authenticated;
  bool persistentSession = false;
  String studentNumber;
  String faculty = 'feup'; // change this
  String type;
  String cookies;
  String password;

  Session(
      {@required bool this.authenticated,
      this.studentNumber,
      this.type,
      this.cookies}) {}

  static Session fromLogin(dynamic response) {
    final responseBody = json.decode(response.body);
    if (responseBody['authenticated']) {
      return Session(
          authenticated: true,
          studentNumber: responseBody['codigo'],
          type: responseBody['tipo'],
          cookies: NetworkRouter.extractCookies(responseBody));
    } else {
      return Session(authenticated: false);
    }
  }

  void setPersistentSession(String password) {
    this.persistentSession = true;
    this.password = password;
  }

}
