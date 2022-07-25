import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/controller/logout.dart';
import 'package:uni/view/Pages/Login/login.dart';

import '../../model/app_state.dart';
import '../../redux/action_creators.dart';

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
