import 'dart:async';

import 'package:flutter/widgets.dart';
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
      PageRouteBuilder<LoginPageView>(
        pageBuilder:
            (context, animation, secondaryAnimation) => const LoginPageView(),
      ),
      (route) => false,
    );
  }

  static PageRouteBuilder<Widget> buildLogoutRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        cleanupStoredData(context);
        return const LoginPageView();
      },
    );
  }
}
