import 'package:flutter/material.dart';

class PageTransition {
  static final int pageTransitionDuration = 200;

  static Route makePageTransition(
      {Widget page, bool maintainState = true, RouteSettings settings}) {
    return PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return page;
        },
        transitionDuration: Duration(milliseconds: pageTransitionDuration),
        settings: settings,
        maintainState: maintainState,
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return FadeTransition(opacity: animation, child: child);
        });
  }
}
