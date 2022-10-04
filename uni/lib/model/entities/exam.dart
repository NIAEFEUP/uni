import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var months = {
  'janeiro': '01',
  'fevereiro': '02',
  'março': '03',
  'abril': '04',
  'maio': '05',
  'junho': '06',
  'julho': '07',
  'agosto': '08',
  'setembro': '09',
  'outubro': '10',
  'novembro': '11',
  'dezembro': '12'
};

var _types = {
  'Mini-testes': 'MT',
  'Normal': 'EN',
  'Recurso': 'ER',
  'Especial de Conclusão': 'EC',
  'Port.Est.Especiais': 'EE',
  'Exames ao abrigo de estatutos especiais': 'EAE'
};

/// Manages a generic Exam.
///
/// The information stored is:
/// - The Exam `subject`
/// - The `begin` and `end` times of the Exam
/// - A List with the `rooms` in which the Exam takes place
/// - The Exam `day`, `weekDay` and `month`
/// - The Exam `type`
class Exam {
  late final String subject;
  late final String begin;
  late final String end;
  late final DateTime beginDateTime;
  late final DateTime endDateTime;
  late final List<String> rooms;
  late final String day;
  late final String examType;
  late final String weekDay;
  late final String month;
  late final String year;
  late final DateTime date;

  Exam.secConstructor(this.subject, this.beginDateTime, this.endDateTime,
      String rooms, this.examType, this.weekDay) {
    begin =
        '${formattedString(beginDateTime.hour)}:${formattedString(beginDateTime.minute)}';
    end =
        '${formattedString(endDateTime.hour)}:${formattedString(endDateTime.minute)}';
    this.rooms = rooms.split(',');
    day = formattedString(beginDateTime.day);
    month = months.keys.firstWhere(
        (k) => months[k] == formattedString(beginDateTime.month),
        orElse: () => '');
    year = beginDateTime.year.toString();
    date = DateTime(beginDateTime.year, beginDateTime.month, beginDateTime.day);
  }

  Exam(DateTime startTime, DateTime endTime, this.subject, String rooms,
      this.examType, this.weekDay) {
    begin = startTime.toString();
    beginDateTime = startTime;
    endDateTime = endTime;
    end = endTime.toString();
    this.rooms = rooms.split(',');
    year = startTime.year.toString();
    day = startTime.day.toString();
    date = DateTime(startTime.year, startTime.month, startTime.day);

    month = months.keys.firstWhere(
        (k) => months[k] == startTime.month.toString(),
        orElse: () => '');
  }

  /// Converts this exam to a map.
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'begin': begin,
      'end': end,
      'rooms': rooms.join(','),
      'day': day,
      'examType': examType,
      'weekDay': weekDay,
      'month': month,
      'year': year
    };
  }

  /// Returns whether or not this exam has already ended.
  bool hasEnded() {
    final DateTime now = DateTime.now();
    return now.compareTo(endDateTime) <= 0;
  }

  /// Prints the data in this exam to the [Logger] with an INFO level.
  void printExam() {
    Logger().i(
        '''$subject - $year - $month - $day -  $begin-$end - $examType - $rooms - $weekDay''');
  }

  @override
  String toString() {
    return '''$subject - $year - $month - $day -  $begin-$end - $examType - $rooms - $weekDay''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exam &&
          runtimeType == other.runtimeType &&
          subject == other.subject &&
          begin == other.begin &&
          end == other.end &&
          listEquals(rooms, other.rooms) &&
          day == other.day &&
          examType == other.examType &&
          weekDay == other.weekDay &&
          month == other.month &&
          year == other.year;

  @override
  int get hashCode =>
      subject.hashCode ^
      begin.hashCode ^
      end.hashCode ^
      rooms.hashCode ^
      day.hashCode ^
      examType.hashCode ^
      weekDay.hashCode ^
      month.hashCode ^
      year.hashCode;

  static Map<String, String> getExamTypes() {
    return _types;
  }

  static getExamTypeLong(String abr) {
    final Map<String, String> reversed = _types.map((k, v) => MapEntry(v, k));
    return reversed[abr];
  }
}

String formattedString(int dateType) {
  if (dateType > 9) {
    return dateType.toString();
  } else {
    return '0$dateType';
  }
}
