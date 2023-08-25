import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

enum WeekDays {
  monday('Segunda', 'Monday'),
  tuesday('Terça', 'Tuesday'),
  wednesday('Quarta', 'Wednesday'),
  thursday('Quinta', 'Thursday'),
  friday('Sexta', 'Friday'),
  saturday('Sábado', 'Saturday'),
  sunday('Domingo', 'Sunday');

  const WeekDays(this.dayPT, this.dayEN);
  final String dayPT;
  final String dayEN;
}

enum Months {
  january('janeiro', 'January'),
  february('fevereiro', 'February'),
  march('março', 'March'),
  april('abril', 'April'),
  may('maio', 'May'),
  june('junho', 'June'),
  july('julho', 'July'),
  august('agosto', 'August'),
  september('setembro', 'September'),
  october('outubro', 'October'),
  november('novembro', 'November'),
  december('dezembro', 'December');

  const Months(this.monthPT, this.monthEN);
  final String monthPT;
  final String monthEN;
}

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

  String locale = Intl.getCurrentLocale();

  String get weekDay {
    if (locale == 'pt_PT') {
      return WeekDays.values[begin.weekday - 1].dayPT;
    } else {
      return WeekDays.values[begin.weekday - 1].dayEN;
    }
  }

  String get month {
    if (locale == 'pt_PT') {
      return Months.values[begin.month - 1].monthPT;
    } else {
      return Months.values[begin.weekday - 1].monthEN;
    }
  }

  String get beginTime => formatTime(begin);

  String get endTime => formatTime(end);

  String formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  @override
  String toString() {
    return '''$id - $subject - ${begin.year} - $month - ${begin.day} -  $beginTime-$endTime - $type - $rooms - $weekDay''';
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
