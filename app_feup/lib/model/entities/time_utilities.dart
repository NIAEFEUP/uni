import 'package:intl/intl.dart';

const weekdays = [
  'N/A',
  'Segunda',
  'Terça',
  'Quarta',
  'Quinta',
  'Sexta',
  'Sábado',
  'Domingo'
];

extension TimeString on DateTime {
  String toTimeHourMinString() {
    return DateFormat('kk:mm').format(this);
  }

  String formatter() {
    final now = DateTime.now();

    final daysDif = now.difference(this).inDays;

    if (daysDif < 1) {
      final hoursDif = now.difference(this).inHours; // hours difference

      if (hoursDif == 0) {
        final minutesDif = now.difference(this).inMinutes; // minutes difference
        return 'Há $minutesDif minutos';
      }
      return 'Há $hoursDif horas';
    } else if (daysDif == 1) {
      return 'Ontem';
    } else if (daysDif < 7) {
      return weekdays[this.weekday];
    } else {
      return DateFormat('dd/MM').format(this); //yyyy-MM-dd – kk:mm
    }
  }
}
