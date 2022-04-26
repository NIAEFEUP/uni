import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeNotifier(this._themeMode);

  ThemeMode _themeMode;

  getTheme() => _themeMode;

  setNextTheme() {
    final nextThemeMode = (_themeMode.index + 1) % 3;
    setTheme(ThemeMode.values[nextThemeMode]);
  }

  setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    AppSharedPreferences.setThemeMode(themeMode);
    notifyListeners();
  }
}
