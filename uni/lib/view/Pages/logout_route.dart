import 'package:flutter/material.dart';
import 'package:uni/controller/logout.dart';
import 'package:uni/view/Pages/login_page_view.dart';

class LogoutRoute {
  LogoutRoute._();
  static MaterialPageRoute buildLogoutRoute() {
    return MaterialPageRoute(builder: (context) {
      logout(context);
      return LoginPageView();
    });
  }
}
