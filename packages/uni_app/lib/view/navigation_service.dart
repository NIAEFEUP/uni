import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni/controller/cleanup.dart';
import 'package:uni/main.dart';
import 'package:uni/view/login/login.dart';

/// Manages the navigation logic
class NavigationService {
  static void logoutAndPopHistory() {
    final context = Application.navigatorKey.currentContext!;

    unawaited(cleanupStoredData(context));

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<LoginPageView>(
        builder: (context) => const LoginPageView(),
      ),
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
