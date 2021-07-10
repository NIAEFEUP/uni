import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeNotifier(this._themeMode);

  ThemeMode _themeMode;

  getTheme() => _themeMode;

  setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    notifyListeners();
  }
}
