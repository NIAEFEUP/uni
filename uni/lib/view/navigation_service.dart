import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni/controller/cleanup.dart';
import 'package:uni/main.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/login/login.dart';

/// Manages the navigation logic
class NavigationService {
  static void logoutAndPopHistory() {
    final context = Application.navigatorKey.currentContext!;

    unawaited(cleanupStoredData(context));

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/${DrawerItem.navLogIn.title}',
      (route) => false,
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
