import 'package:flutter/material.dart';
import 'package:uni/utils/constants.dart' as constants;

/// Manages the navigation logic
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static logout() {
    navigatorKey.currentState!
        .pushNamedAndRemoveUntil('/${constants.navLogOut}', (_) => false);
  }
}
