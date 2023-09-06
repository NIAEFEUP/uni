import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/app_locale.dart';

class LocaleNotifier with ChangeNotifier {
  LocaleNotifier(this._locale);

  AppLocale _locale;

  AppLocale getLocale() => _locale;

  void setNextLocale() {
    const availableLocales = AppLocale.values;
    final currentIndex = availableLocales.indexOf(_locale);
    final nextLocale =
        availableLocales[(currentIndex + 1) % availableLocales.length];
    setLocale(nextLocale);
  }

  void setLocale(AppLocale locale) {
    _locale = locale;
    AppSharedPreferences.setLocale(locale);
    notifyListeners();
  }

  List<String> getWeekdaysWithLocale() {
    final weekdays = DateFormat.EEEE(_locale.localeCode.languageCode)
        .dateSymbols
        .WEEKDAYS
        .skip(1)
        .map((weekday) => weekday[0].toUpperCase() + weekday.substring(1))
        .toList()
      ..add(_locale == AppLocale.en ? 'Sunday' : 'Domingo');
    return weekdays;
  }
}
