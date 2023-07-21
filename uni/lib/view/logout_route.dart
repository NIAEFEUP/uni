import 'package:flutter/material.dart';
import 'package:uni/controller/logout.dart';
import 'package:uni/view/login/login.dart';

class LogoutRoute {
  LogoutRoute._();

  static MaterialPageRoute buildLogoutRoute() {
    return MaterialPageRoute(builder: (context) {
      logout(context);
      return const LoginPageView();
    },);
  }
}
