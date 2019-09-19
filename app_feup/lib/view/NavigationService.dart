import 'package:flutter/material.dart';

import '../Main.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  static logout() {
    navigatorKey.currentState.pushNamedAndRemoveUntil('/' + NAV_LOG_OUT, (_) => false);
  }
}