import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();
  static logout() {
    navigatorKey.currentState.pushNamedAndRemoveUntil('/Terminar sessão', (_) => false);
  }
}