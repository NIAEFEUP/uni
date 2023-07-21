import 'package:flutter/material.dart';
import 'package:uni/utils/drawer_items.dart';

/// Manages the navigation logic
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static logout() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/${DrawerItem.navLogOut.title}',
      (_) => false,
    );
  }
}
