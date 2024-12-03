import 'package:intl/intl.dart';
import 'package:uni/model/entities/app_locale.dart';

extension DateTimeExtensions on DateTime {
  String weekDay(AppLocale locale) {
    return DateFormat.EEEE(locale.localeCode.languageCode)
        .dateSymbols
        .WEEKDAYS[weekday % 7];
  }

  String fullMonth(AppLocale locale) {
    return DateFormat.EEEE(locale.localeCode.languageCode)
        .dateSymbols
        .MONTHS[month - 1];
  }

  String shortMonth(AppLocale locale) {
    return DateFormat.EEEE(locale.localeCode.languageCode)
        .dateSymbols
        .SHORTMONTHS[month - 1]
        .replaceAll('.', '');
  }

  String formattedDate(AppLocale locale) {
    return DateFormat.MMMMd(locale.localeCode.languageCode).format(this);
  }
}
