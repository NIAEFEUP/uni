import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

enum WeekDays {
  monday("Segunda"),
  tuesday("Terça"),
  wednesday("Quarta"),
  thursday("Quinta"),
  friday("Sexta"),
  saturday("Sábado"),
  sunday("Domingo");

  final String day;
  const WeekDays(this.day);
}

enum Months {
  january("Janeiro"),
  february("Fevereiro"),
  march("Março"),
  april("Abril"),
  may("Maio"),
  june("Junho"),
  july("Julho"),
  august("Agosto"),
  september("Setembro"),
  october("Outubro"),
  november("Novembro"),
  december("Dezembro");

  final String month;
  const Months(this.month);
}

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
  late final String id;

  late final String subject;
  late final List<String> rooms;
  late final String type;
  bool isHidden = false;

  static Map<String, String> types = {
    'Mini-testes': 'MT',
    'Normal': 'EN',
    'Recurso': 'ER',
    'Especial de Conclusão': 'EC',
    'Port.Est.Especiais': 'EE',
    'Exames ao abrigo de estatutos especiais': 'EAE'
  };
  Exam(this.id, this.begin, this.end, this.subject, this.rooms, this.type);

  Exam.secConstructor(this.id,
      this.subject, this.begin, this.end, String rooms, this.type) {
    this.rooms = rooms.split(',');
  }

  /// Converts this exam to a map.
  Map<String, String> toMap() {
    return {
      'id': id,
      'subject': subject,
      'begin': beginTime,
      'end': endTime,
      'rooms': rooms.join(','),
      'day': begin.day.toString(),
      'examType': type,
      'weekDay': weekDay,
      'month': month,
      'year': begin.year.toString()
    };
  }


  /// Returns whether or not this exam has already ended.
  bool hasEnded() => DateTime.now().compareTo(end) >= 0;

  String get weekDay => WeekDays.values[begin.weekday - 1].day;

  String get month => Months.values[begin.month - 1].month;

  String get beginTime => formatTime(begin);

  String get endTime => formatTime(end);

  String formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  /// the type 'MT' ('Mini-testes') or 'EN' ('Normal').
  bool isHighlighted() => type == 'MT' || type == 'EN';

  @override
  String toString() {
    return '''$id - $subject - ${begin.year.toString()} - $month - ${begin.day} -  $beginTime-$endTime - $type - $rooms - $weekDay''';
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
      begin.hashCode ^
      end.hashCode ^
      subject.hashCode ^
      rooms.hashCode ^
      type.hashCode;

  static getExamTypeLong(String abr) {
    final Map<String, String> reversed = types.map((k, v) => MapEntry(v, k));
    return reversed[abr];
  }
}
