import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';

part 'exam.g.dart';

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
  january("janeiro"),
  february("fevereiro"),
  march("março"),
  april("abril"),
  may("maio"),
  june("junho"),
  july("julho"),
  august("agosto"),
  september("setembro"),
  october("outubro"),
  november("novembro"),
  december("dezembro");

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

@JsonSerializable()
class Exam {
  late final DateTime begin;
  late final DateTime end;
  late final String id;
  late final String subject;
  late final List<String> rooms;
  late final String type;
  late final String faculty;

  static Map<String, String> types = {
    'Mini-testes': 'MT',
    'Normal': 'EN',
    'Recurso': 'ER',
    'Especial de Conclusão': 'EC',
    'Port.Est.Especiais': 'EE',
    'Exames ao abrigo de estatutos especiais': 'EAE'
  };

  Exam(this.id, this.begin, this.end, this.subject, this.rooms, this.type,
      this.faculty);
  static List<String> displayedTypes = types.keys.toList().sublist(0, 4);

  Exam.secConstructor(this.id, this.subject, this.begin, this.end, String rooms,
      this.type, this.faculty) {
    this.rooms = rooms.split(',');
  }

  factory Exam.fromJson(Map<String,dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);

  /// Returns whether or not this exam has already ended.
  bool hasEnded() => DateTime.now().compareTo(end) >= 0;

  String get weekDay => WeekDays.values[begin.weekday - 1].day;

  String get month => Months.values[begin.month - 1].month;

  String get beginTime => formatTime(begin);

  String get endTime => formatTime(end);

  String formatTime(DateTime time) => DateFormat('HH:mm').format(time);

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
      identical(this, other) || other is Exam && id == other.id;

  @override
  int get hashCode => id.hashCode;

  static getExamTypeLong(String abr) {
    final Map<String, String> reversed = types.map((k, v) => MapEntry(v, k));
    return reversed[abr];
  }
}
