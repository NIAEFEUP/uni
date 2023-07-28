import 'package:flutter/material.dart';

/// Transition used between pages
class PageTransition {
  static const int pageTransitionDuration = 200;

  static Route<Widget> makePageTransition({
    required Widget page,
    required RouteSettings settings,
    bool maintainState = true,
  }) {
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return page;
      },
      transitionDuration: const Duration(milliseconds: pageTransitionDuration),
      settings: settings,
      maintainState: maintainState,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
