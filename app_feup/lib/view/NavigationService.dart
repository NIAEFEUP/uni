import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  static  navigateTo(String routeName) {
    navigatorKey.currentState.pushNamedAndRemoveUntil('/Login', (_) => false);
  }
}