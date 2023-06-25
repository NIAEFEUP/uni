import 'package:flutter/material.dart';
import 'dart:io';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeNotifier(this._themeMode, this._locale);

  ThemeMode _themeMode;
  Locale _locale;

  getTheme() => _themeMode;

  getLocale() => _locale;

  setNextTheme() {
    final nextThemeMode = (_themeMode.index + 1) % 3;
    setTheme(ThemeMode.values[nextThemeMode]);
  }

  setTheme(ThemeMode themeMode) {
    _themeMode = themeMode;
    AppSharedPreferences.setThemeMode(themeMode);
    notifyListeners();
  }

  setNextLocale() {
    final nextLocale;
    if(_locale == Locale('pt', 'PT')) nextLocale = Locale('en', 'US');
    else nextLocale = Locale('pt', 'PT');
    setLocale(nextLocale);
  }

  setLocale(Locale locale) {
    _locale = locale;
    AppSharedPreferences.setLocale(locale);
    notifyListeners();
  }
}





