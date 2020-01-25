import 'package:flutter/material.dart';

import '../utils/Constants.dart' as Constants;

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  static logout() {
    navigatorKey.currentState.pushNamedAndRemoveUntil('/' + Constants.NAV_LOG_OUT, (_) => false);
  }
}