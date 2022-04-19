import 'package:intl/intl.dart';

extension TimeString on DateTime {
  static const weekdays = [
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
    'Domingo'
  ];

  String toTimeHourMinString() {
    return DateFormat('kk:mm').format(this);
  }

  String plural(n) => n != 1 ? 's' : '';

  String toFormattedDateString() {
    final now = DateTime.now();
    final daysDif = now.difference(this).inDays;

    if (daysDif == 0) {
      final hoursDif = now.difference(this).inHours;
      if (hoursDif == 0) {
        final minutesDif = now.difference(this).inMinutes;
        if (minutesDif < 1) {
          return 'Agora mesmo';
        }
        return 'Há $minutesDif minuto' + plural(minutesDif);
      }
      return 'Há $hoursDif hora' + plural(hoursDif);
    }
    if (daysDif == 1) {
      return 'Ontem';
    }
    if (daysDif > 0 && daysDif < 7) {
      return weekdays[this.weekday-1];
    }
    return DateFormat('dd/MM').format(this);
  }
}
