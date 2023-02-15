extension TimeString on DateTime {
  String toTimeHourMinString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  static List<String> getWeekdaysStrings({bool startMonday = true, bool includeWeekend = true}) {
    final List<String> weekdays = [
      'Segunda-Feira',
      'Terça-Feira',
      'Quarta-Feira',
      'Quinta-Feira',
      'Sexta-Feira',
      'Sábado',
      'Domingo'
    ];

    if (!startMonday) {
      weekdays.removeAt(6);
      weekdays.insert(0, 'Domingo');
    }

    return includeWeekend ? weekdays : weekdays.sublist(0, 5);
  }
}
