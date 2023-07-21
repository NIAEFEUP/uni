import 'package:flutter/material.dart';

/// Transition used between pages
class PageTransition {
  static const int pageTransitionDuration = 200;

  static Route makePageTransition(
      {required Widget page,
      bool maintainState = true,
      required RouteSettings settings,}) {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation,) {
          return page;
        },
        transitionDuration:
            const Duration(milliseconds: pageTransitionDuration),
        settings: settings,
        maintainState: maintainState,
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child,) {
          return FadeTransition(opacity: animation, child: child);
        },);
  }
}
