import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/logout.dart';
import 'package:uni/view/login/login.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';

class LogoutRoute {
  LogoutRoute._();
  static MaterialPageRoute buildLogoutRoute() {
    return MaterialPageRoute(builder: (context) {
      logout(context);
      StoreProvider.of<AppState>(context).dispatch(setInitialStoreState());
      return const LoginPageView();
    });
  }
}
