import 'package:flutter/material.dart';
import 'package:uni/controller/cleanup.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/login/login.dart';

/// Manages the navigation logic
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void logoutAndPopHistory(BuildContext? dataContext) {
    if (dataContext != null) {
      cleanupStoredData(dataContext);
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/${DrawerItem.navLogOut.title}',
      (_) => false,
    );
  }

  static MaterialPageRoute<Widget> buildLogoutRoute() {
    return MaterialPageRoute(
      builder: (context) {
        cleanupStoredData(context);
        return const LoginPageView();
      },
    );
  }
}
