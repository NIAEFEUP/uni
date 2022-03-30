import 'package:logger/logger.dart';
import 'package:collection/collection.dart';

var months = {
  'Janeiro': '01',
  'Fevereiro': '02',
  'Março': '03',
  'Abril': '04',
  'Maio': '05',
  'Junho': '06',
  'Julho': '07',
  'Agosto': '08',
  'Setembro': '09',
  'Outubro': '10',
  'Novembro': '11',
  'Dezembro': '12'
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
  String subject;
  String begin;
  String end;
  DateTime beginDateTime;
  DateTime endDateTime;
  List<String> rooms;
  String day;
  String examType;
  String weekDay;
  String month;
  String year;
  DateTime date;

  Exam.secConstructor(String subject, DateTime beginDateTime,
   DateTime endDateTime, String rooms, String examType, String weekDay) {
    this.subject = subject;
    this.beginDateTime = beginDateTime;
    this.endDateTime = endDateTime;
    this.begin = formattedString(beginDateTime.hour) + ':' +
    formattedString(beginDateTime.minute);
    this.end = formattedString(endDateTime.hour) + ':' + 
    formattedString(endDateTime.minute);
    this.rooms = rooms.split(',');
    this.examType = examType;
    this.weekDay = weekDay;
    this.day = formattedString(beginDateTime.day);
    this.month = months.keys
        .firstWhere((k) => months[k] == formattedString(beginDateTime.month),
        orElse: () => null);
    this.year = beginDateTime.year.toString();
    this.date = 
    DateTime(beginDateTime.year,beginDateTime.month,beginDateTime.day);
  }

  Exam(String schedule, String subject, String rooms, String date,
      String examType, String weekDay) {
    final scheduling = schedule.split('-');
    final splitDate = date.split('-');
    this.date = DateTime.parse(date);

    this.endDateTime = 
    DateTime(this.date.year, this.date.month, this.date.day,
    int.parse(scheduling[1].split(':')[0]),
    int.parse(scheduling[1].split(':')[1]));

    this.beginDateTime = 
    DateTime(this.date.year, this.date.month, this.date.day,
    int.parse(scheduling[0].split(':')[0]),
    int.parse(scheduling[0].split(':')[1]));

    this.begin =  scheduling[0];
    this.end = scheduling[1];
    this.subject = subject;
    this.rooms = rooms.split(',');
    this.year = splitDate[0];
    this.day = splitDate[2];
    this.examType = examType;
    this.weekDay = weekDay;

    this.month = months.keys
        .firstWhere((k) => months[k] == splitDate[1], orElse: () => null);
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
          ListEquality().equals(rooms, other.rooms) &&
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
      ListEquality().hash(rooms) ^
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
String formattedString(int dateType){
    if (dateType>9){
    return dateType.toString();
    }
    else {
      return '0'+dateType.toString();
    }
  }
