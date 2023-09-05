import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/app_locale.dart';

class LocaleNotifier with ChangeNotifier {
  LocaleNotifier(this._locale);

  AppLocale _locale;

  AppLocale getLocale() => _locale;

  void setNextLocale() {
    final AppLocale nextLocale;
    _locale == AppLocale.pt
        ? nextLocale = AppLocale.en
        : nextLocale = AppLocale.pt;
    setLocale(nextLocale);
  }

  void setLocale(AppLocale locale) {
    _locale = locale;
    AppSharedPreferences.setLocale(locale.localeCode.languageCode);
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
