import 'package:intl/intl.dart';
import 'package:uni/model/entities/app_locale.dart';

/// Manages a generic Exam.
///
/// The information stored is:
/// - The `begin` and `end` times of the Exam
/// - The Exam `subject`
/// - A List with the `rooms` in which the Exam takes place
/// - The Exam `type`
class Exam {
  Exam(
    this.id,
    this.begin,
    this.end,
    this.subject,
    this.rooms,
    this.type,
    this.faculty,
  );

  Exam.secConstructor(
    this.id,
    this.subject,
    this.begin,
    this.end,
    String rooms,
    this.type,
    this.faculty,
  ) : rooms = rooms.split(',');

  final DateTime begin;
  final DateTime end;
  final String id;
  final String subject;
  final List<String> rooms;
  final String type;
  final String faculty;

  static Map<String, String> types = {
    'Mini-testes': 'MT',
    'Normal': 'EN',
    'Recurso': 'ER',
    'Especial de Conclusão': 'EC',
    'Port.Est.Especiais': 'EE',
    'Exames ao abrigo de estatutos especiais': 'EAE'
  };
  static List<String> displayedTypes = types.keys.toList().sublist(0, 4);

  /// Converts this exam to a map.
  Map<String, String> toMap() {
    return {
      'id': id,
      'subject': subject,
      'begin': DateFormat('yyyy-MM-dd HH:mm:ss').format(begin),
      'end': DateFormat('yyyy-MM-dd HH:mm:ss').format(end),
      'rooms': rooms.join(','),
      'examType': type,
      'faculty': faculty
    };
  }

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
    return '''$id - $subject - ${begin.year} - $month - ${begin.day} -  $beginTime-$endTime - $type - $rooms - $weekDay''';
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
