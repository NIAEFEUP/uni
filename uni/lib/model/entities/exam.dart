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
  late final String type;

  static Map<String, String> types = {
    'Mini-testes': 'MT',
    'Normal': 'EN',
    'Recurso': 'ER',
    'Especial de Conclusão': 'EC',
    'Port.Est.Especiais': 'EE',
    'Exames ao abrigo de estatutos especiais': 'EAE'
  };

  Exam(this.begin, this.end, this.subject, this.rooms, this.type);

  Exam.secConstructor(
      this.subject, this.begin, this.end, String rooms, this.type) {
    this.rooms = rooms.split(',');
  }

  /// Converts this exam to a map.
  Map<String, String> toMap() {
    return {
      'subject': subject,
      'begin': beginTime(),
      'end': endTime(),
      'rooms': rooms.join(','),
      'day': begin.day.toString(),
      'examType': type,
      'weekDay': getWeekDay(),
      'month': getMonth(),
      'year': begin.year.toString()
    };
  }

  /// Returns whether or not this exam has already ended.
  bool hasEnded() => DateTime.now().compareTo(end) >= 0;
  
  String getMonth() => months[begin.month - 1];

  String getWeekDay() => weekDays[begin.weekday - 1];

  String beginTime() => formatTime(begin);

  String endTime() => formatTime(end);

  String formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  /// the type 'MT' ('Mini-testes') or 'EN' ('Normal').
  bool isHighlighted() => type == 'MT' || type == 'EN';

  @override
  String toString() {
    return '''$subject - ${begin.year.toString()} - ${getMonth()} - ${begin.day} -  ${beginTime()}-${endTime()} - $type - $rooms - ${getWeekDay()}''';
  }

  /// Prints the data in this exam to the [Logger] with an INFO level.
  void printExam() {
    Logger().i(toString());
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
      type == other.type;

  @override
  int get hashCode =>
      begin.hashCode ^ end.hashCode ^ subject.hashCode ^ rooms.hashCode ^ type.hashCode;

  static getExamTypeLong(String abr) {
    final Map<String, String> reversed = types.map((k, v) => MapEntry(v, k));
    return reversed[abr];
  }
}
