enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

DayOfWeek parseDateTime(DateTime dateTime) {
  final weekDay = dateTime.weekday;
  switch (weekDay) {
    case DateTime.monday:
      return DayOfWeek.monday;
    case DateTime.tuesday:
      return DayOfWeek.tuesday;
    case DateTime.wednesday:
      return DayOfWeek.wednesday;
    case DateTime.thursday:
      return DayOfWeek.thursday;
    case DateTime.friday:
      return DayOfWeek.friday;
    case DateTime.saturday:
      return DayOfWeek.saturday;
    case DateTime.sunday:
      return DayOfWeek.sunday;
    default:
      throw Exception('Invalid day of week');
  }
}

DayOfWeek? parseDayOfWeek(String str) {
  final weekDay = str.replaceAll(' ', '').toLowerCase();
  if (weekDay == 'segunda-feira') {
    return DayOfWeek.monday;
  } else if (weekDay == 'terça-feira') {
    return DayOfWeek.tuesday;
  } else if (weekDay == 'quarta-feira') {
    return DayOfWeek.wednesday;
  } else if (weekDay == 'quinta-feira') {
    return DayOfWeek.thursday;
  } else if (weekDay == 'sexta-feira') {
    return DayOfWeek.friday;
  } else if (weekDay == 'sábado' || weekDay == 'sabado') {
    return DayOfWeek.saturday;
  } else if (weekDay == 'domingo') {
    return DayOfWeek.sunday;
  }
  return null;
}

String toString(DayOfWeek day) {
  switch (day) {
    case DayOfWeek.monday:
      return 'Segunda-feira';
    case DayOfWeek.tuesday:
      return 'Terça-feira';
    case DayOfWeek.wednesday:
      return 'Quarta-feira';
    case DayOfWeek.thursday:
      return 'Quinta-feira';
    case DayOfWeek.friday:
      return 'Sexta-feira';
    case DayOfWeek.saturday:
      return 'Sábado';
    case DayOfWeek.sunday:
      return 'Domingo';
  }
}
