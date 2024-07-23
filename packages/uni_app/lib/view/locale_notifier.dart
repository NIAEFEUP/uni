import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
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
    PreferencesController.setLocale(locale);
    notifyListeners();
  }

  List<String> getWeekdaysWithLocale() {
    final allWeekDays = DateFormat.EEEE().dateSymbols.WEEKDAYS;
    final europeanWeekDays = allWeekDays.skip(1).toList()
      ..add(allWeekDays.first);
    return europeanWeekDays
        .map((weekday) => weekday[0].toUpperCase() + weekday.substring(1))
        .toList();
  }
}
