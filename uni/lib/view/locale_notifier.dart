import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

class LocaleNotifier with ChangeNotifier {
  LocaleNotifier(this._locale);

  Locale _locale;

  getLocale() => _locale;

  setNextLocale() {
    final Locale nextLocale;
    _locale == const Locale('pt') ? nextLocale = const Locale('en') : nextLocale = const Locale('pt');
    setLocale(nextLocale);
  }

  setLocale(Locale locale) {
    _locale = locale;
    AppSharedPreferences.setLocale(locale.languageCode);
    notifyListeners();
  }
}





