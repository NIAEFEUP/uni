import 'package:flutter/material.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:intl/intl.dart';

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

  getWeekdaysWithLocale() {
    final List<String> weekdays = [];
    for(String weekday in DateFormat.EEEE(_locale.languageCode).dateSymbols.WEEKDAYS){
      weekdays.add(weekday[0].toUpperCase() + weekday.substring(1));
    }
    weekdays.removeAt(0);
    weekdays[5] == 'Saturday' ? weekdays.add('Sunday') : weekdays.add('Domingo');
    return weekdays;
  }
}





