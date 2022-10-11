import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

List<String> months = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro'
];

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
  late final DateTime begin;
  late final DateTime end;
  late final String subject;
  late final List<String> rooms;
  late final String examType;
  late final String weekDay;

  Exam.secConstructor(this.subject, this.begin, this.end, String rooms,
      this.examType, this.weekDay) {
    this.rooms = rooms.split(',');
  }

  Exam(this.begin, this.end, this.subject, this.rooms, this.examType,
      this.weekDay);

  /// Converts this exam to a map.
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'begin': beginTime(),
      'end': endTime(),
      'rooms': rooms.join(','),
      'day': begin.day,
      'examType': examType,
      'weekDay': weekDay,
      'month': getMonth(),
      'year': begin.year.toString()
    };
  }

  /// Returns whether or not this exam has already ended.
  bool hasEnded() {
    final DateTime now = DateTime.now();
    return now.compareTo(end) >= 0;
  }

  String getMonth() {
    return months[begin.month - 1];
  }

  String beginTime() {
    return '${formattedString(begin.hour)}:${formattedString(begin.minute)}';
  }

  String endTime() {
    return '${formattedString(end.hour)}:${formattedString(end.minute)}';
  }

  /// the type 'MT' ('Mini-testes') or 'EN' ('Normal').
  bool isHighlighted() {
    return (examType.contains('''EN''')) || (examType.contains('''MT'''));
  }

  /// Prints the data in this exam to the [Logger] with an INFO level.
  void printExam() {
    Logger().i(
        '''$subject - ${begin.year.toString()} - ${getMonth()} - ${begin.day} -  ${beginTime()}-${endTime()} - $examType - $rooms - $weekDay''');
  }

  @override
  String toString() {
    return '''$subject - ${begin.year.toString()} - ${getMonth()} - ${begin.day} -  ${beginTime()}-${endTime()} - $examType - $rooms - $weekDay''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exam &&
          runtimeType == other.runtimeType &&
          subject == other.subject &&
          listEquals(rooms, other.rooms) &&
          begin.day == other.begin.day &&
          begin == other.begin &&
          end == other.end &&
          examType == other.examType &&
          weekDay == other.weekDay;

  @override
  int get hashCode =>
      subject.hashCode ^
      beginTime().hashCode ^
      endTime().hashCode ^
      rooms.hashCode ^
      begin.day.hashCode ^
      examType.hashCode ^
      weekDay.hashCode ^
      getMonth().hashCode ^
      begin.year.toString().hashCode;

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
