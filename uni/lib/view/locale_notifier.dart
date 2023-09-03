import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';

class LocaleNotifier with ChangeNotifier {
  LocaleNotifier(this._locale);

  Locale _locale;

  Locale getLocale() => _locale;

  void setNextLocale() {
    final Locale nextLocale;
    _locale == const Locale('pt')
        ? nextLocale = const Locale('en')
        : nextLocale = const Locale('pt');
    setLocale(nextLocale);
  }

  void setLocale(Locale locale) {
    _locale = locale;
    AppSharedPreferences.setLocale(locale.languageCode);
    notifyListeners();
  }

  List<String> getWeekdaysWithLocale() {
    final weekdays = DateFormat.EEEE(_locale.languageCode)
        .dateSymbols
        .WEEKDAYS
        .skip(1)
        .map((weekday) => weekday[0].toUpperCase() + weekday.substring(1))
        .toList()
      ..add(_locale.languageCode == 'en' ? 'Sunday' : 'Domingo');
    return weekdays;
  }
}
