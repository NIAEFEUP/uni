import 'package:intl/intl.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';

part 'exam.g.dart';

enum WeekDays {
  monday('Segunda'),
  tuesday('Terça'),
  wednesday('Quarta'),
  thursday('Quinta'),
  friday('Sexta'),
  saturday('Sábado'),
  sunday('Domingo');

  const WeekDays(this.day);

  final String day;
}

enum Months {
  january('janeiro'),
  february('fevereiro'),
  march('março'),
  april('abril'),
  may('maio'),
  june('junho'),
  july('julho'),
  august('agosto'),
  september('setembro'),
  october('outubro'),
  november('novembro'),
  december('dezembro');

  const Months(this.month);

  final String month;
}

class DateTimeConverter extends JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    final format = DateFormat('d-M-y');
    return format.parse(json);
  }

  @override
  String toJson(DateTime object) {
    final format = DateFormat('d-M-y');
    return format.format(object);
  }
}

/// Manages a generic Exam.
///
/// The information stored is:
/// - The `begin` and `end` times of the Exam
/// - The Exam `subject`
/// - A List with the `rooms` in which the Exam takes place
/// - The Exam `type`

@DateTimeConverter()
@JsonSerializable()
class Exam {
  Exam(
    this.id,
    this.begin,
    this.end,
    this.subject,
    this.rooms,
    this.examType,
    this.faculty,
  );

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

  Exam.secConstructor(
    this.id,
    this.subject,
    this.begin,
    this.end,
    String rooms,
    this.examType,
    this.faculty,
  ) : rooms = rooms.split(',');

  final DateTime begin;
  final DateTime end;
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
  bool hasEnded() => DateTime.now().compareTo(end) >= 0;

  String weekDay(AppLocale locale) {
    return DateFormat.EEEE(locale.localeCode.languageCode)
        .dateSymbols
        .WEEKDAYS[begin.weekday % 7];
  }

  String month(AppLocale locale) {
    return DateFormat.EEEE(locale.localeCode.languageCode)
        .dateSymbols
        .MONTHS[begin.month - 1];
  }

  String get beginTime => formatTime(begin);

  String get endTime => formatTime(end);

  String formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  @override
  String toString() {
    return '''$id - $subject - ${begin.year} - $month - ${begin.day} -  $beginTime-$endTime - $examType - $rooms - $weekDay''';
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

  static String? getExamTypeLong(String abr) {
    final reversed = types.map((k, v) => MapEntry(v, k));
    return reversed[abr];
  }
}
