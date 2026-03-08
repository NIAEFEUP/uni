import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/app_locale.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLocale>(
  (ref) => LocaleNotifier(PreferencesController.getLocale()),
);

class LocaleNotifier extends StateNotifier<AppLocale> {
  LocaleNotifier(super.initialLocale);

  AppLocale getLocale() => state;

  void setNextLocale() {
    const availableLocales = AppLocale.values;
    final currentIndex = availableLocales.indexOf(state);
    final nextLocale =
        availableLocales[(currentIndex + 1) % availableLocales.length];
    setLocale(nextLocale);
  }

  void setLocale(AppLocale locale) {
    state = locale;
    PreferencesController.setLocale(locale);
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
