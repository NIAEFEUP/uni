import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/reference.dart';

part '../../generated/model/entities/exam.g.dart';

/// Manages a generic Exam.
///
/// The information stored is:
/// - The `start` and `finish` times of the Exam
/// - The Exam `subject`
/// - A List with the `rooms` in which the Exam takes place
/// - The Exam `type`

@DateTimeConverter()
@JsonSerializable()
class Exam {
  Exam(
    this.id,
    this.start,
    this.finish,
    this.subject,
    this.rooms,
    this.examType,
    this.faculty,
  );

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

  Exam.secConstructor(
    this.id,
    this.subject,
    this.start,
    this.finish,
    String rooms,
    this.examType,
    this.faculty,
  ) : rooms = rooms.split(',');

  final DateTime start;
  final DateTime finish;
  final String id;
  final String subject;
  final List<String> rooms;
  final String examType;
  final String faculty;

  static Map<String, String> types = {
    'Mini-testes': 'MT',
    'Normal': 'EN',
    'Recurso': 'ER',
    'Especial de Conclusão': 'EC',
    'Port.Est.Especiais': 'EE',
    'Exames ao abrigo de estatutos especiais': 'EAE',
  };
  static List<String> displayedTypes = types.keys.toList().sublist(0, 4);
  Map<String, dynamic> toJson() => _$ExamToJson(this);

  /// Returns whether or not this exam has already ended.
  bool hasEnded() => DateTime.now().compareTo(finish) >= 0;

  String weekDay(AppLocale locale) {
    return DateFormat.EEEE(locale.localeCode.languageCode)
        .dateSymbols
        .WEEKDAYS[start.weekday % 7];
  }

  String month(AppLocale locale) {
    return DateFormat.EEEE(locale.localeCode.languageCode)
        .dateSymbols
        .MONTHS[start.month - 1];
  }

  String get startTime => formatTime(start);

  String get finishTime => formatTime(finish);

  String formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  @override
  String toString() {
    return '''$id - $subject - ${start.year} - $month - ${start.day}  -  $startTime-$finishTime - $examType - $rooms - $weekDay''';
  }

  /// Prints the data in this exam to the [Logger] with an INFO level.
  void printExam() {
    Logger().i(toString());
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exam && id == other.id && subject == other.subject;

  @override
  int get hashCode => id.hashCode;

  static String? getExamTypeLong(String abr) {
    final reversed = types.map((k, v) => MapEntry(v, k));
    return reversed[abr];
  }
}
