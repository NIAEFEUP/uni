import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeNotifier(this._themeMode);

  ThemeMode _themeMode;

  ThemeMode getTheme() => _themeMode;

  void setNextTheme() {
    final nextThemeMode = (_themeMode.index + 1) % 3;
    setTheme(ThemeMode.values[nextThemeMode]);
  }

  void setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    PreferencesController.setThemeMode(themeMode);
    notifyListeners();
  }
}
