import 'package:flutter/material.dart';

import '../utils/constants.dart' as Constants;

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  static logout() {
    navigatorKey.currentState.pushNamedAndRemoveUntil('/' + Constants.navLogOut, (_) => false);
  }
}