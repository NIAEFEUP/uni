import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

const List<String> weekDays = [
  'Segunda',
  'Terça',
  'Quarta',
  'Quinta',
  'Sexta',
  'Sábado',
  'Domingo'
];

const List<String> months = [
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

const Map<String, String> _types = {
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
/// - The `begin` and `end` times of the Exam
/// - The Exam `subject`
/// - A List with the `rooms` in which the Exam takes place
/// - The Exam `type`

class Exam {
  late final DateTime begin;
  late final DateTime end;
  late final String subject;
  late final List<String> rooms;
  late final String examType;

  Exam.secConstructor(
      this.subject, this.begin, this.end, String rooms, this.examType) {
    this.rooms = rooms.split(',');
  }

  Exam(this.begin, this.end, this.subject, this.rooms, this.examType);

  /// Converts this exam to a map.
  Map<String, String> toMap() {
    return {
      'subject': subject,
      'begin': beginTime(),
      'end': endTime(),
      'rooms': rooms.join(','),
      'day': begin.day.toString(),
      'examType': examType,
      'weekDay': getWeekDay(),
      'month': getMonth(),
      'year': begin.year.toString()
    };
  }

  /// Returns whether or not this exam has already ended.
  bool hasEnded() {
    return DateTime.now().compareTo(end) >= 0;
  }

  String getMonth() => months[begin.month - 1];

  String getWeekDay() => weekDays[begin.weekday - 1];

  String beginTime() => formatTime(begin);

  String endTime() => formatTime(end);

  String formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  /// the type 'MT' ('Mini-testes') or 'EN' ('Normal').
  bool isHighlighted() {
    return (examType.contains('''EN''')) || (examType.contains('''MT'''));
  }

  /// Prints the data in this exam to the [Logger] with an INFO level.
  void printExam() {
    Logger().i(toString());
  }

  @override
  String toString() {
    return '''$subject - ${begin.year.toString()} - ${getMonth()} - ${begin.day} -  ${beginTime()}-${endTime()} - $examType - $rooms - ${getWeekDay()}''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exam &&
          runtimeType == other.runtimeType &&
          subject == other.subject &&
          listEquals(rooms, other.rooms) &&
          begin == other.begin &&
          end == other.end &&
          examType == other.examType;

  @override
  int get hashCode =>
      subject.hashCode ^
      beginTime().hashCode ^
      endTime().hashCode ^
      rooms.hashCode ^
      begin.day.hashCode ^
      examType.hashCode ^
      getWeekDay().hashCode ^
      getMonth().hashCode ^
      begin.year.toString().hashCode;

  static Map<String, String> getExamTypes() => _types;

  static getExamTypeLong(String abr) {
    final Map<String, String> reversed = _types.map((k, v) => MapEntry(v, k));
    return reversed[abr];
  }
}
