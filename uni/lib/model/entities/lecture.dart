import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:uni/model/utils/datetime.dart';

/// Stores information about a lecture.
class Lecture {
  static var dayName = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira',
    'Sábado',
    'Domingo'
  ];
  String subject;
  DateTime startTime;
  DateTime endTime;
  String typeClass;
  String room;
  String teacher;
  String classNumber;
  int day;
  int occurrId;

  /// Creates an instance of the class [Lecture].
  Lecture(
      this.subject,
      this.typeClass,
      this.day,
      this.room,
      this.teacher,
      this.classNumber,
      this.startTime,
      this.endTime,
      this.occurrId);

  factory Lecture.fromApi(
      String subject,
      String typeClass,
      int day,
      int startTimeSeconds,
      int blocks,
      String room,
      String teacher,
      String classNumber,
      int occurrId) {
    final startTimeHours = (startTimeSeconds ~/ 3600);
    final startTimeMinutes = ((startTimeSeconds % 3600) ~/ 60);
    final startTime = DateTime(1, 1, 1, startTimeHours, startTimeMinutes, 0);
    final endTime = startTime.add(Duration(minutes:blocks*30));
    final lecture = Lecture(
        subject,
        typeClass,
        day,
        room,
        teacher,
        classNumber,
        startTime,
        endTime,
        occurrId
        );
    return lecture;
  }

  factory Lecture.fromHtml(
      String subject,
      String typeClass,
      int day,
      String startTime,
      int blocks,
      String room,
      String teacher,
      String classNumber,
      int occurrId) {
        
    final start = DateFormat.Hm().parse(startTime);
    final end = start.add(Duration(minutes:blocks*30));
    return Lecture(subject, typeClass, day, room, teacher, classNumber,
        start, end, occurrId);
  }

  /// Clones a lecture from the api.
  static Lecture clone(Lecture lec) {
    return Lecture(
      lec.subject,
      lec.typeClass,
      lec.day,
      lec.room,
      lec.teacher,
      lec.classNumber,
      lec.startTime,
      lec.endTime,
      lec.occurrId
    );
  }

  /// Converts this lecture to a map.
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'typeClass': typeClass,
      'day': day,
      'startTime': startTime,
      'room': room,
      'teacher': teacher,
      'classNumber': classNumber,
      'occurrId': occurrId
    };
  }

  /// Prints the data in this lecture to the [Logger] with an INFO level.
  printLecture() {
    Logger().i('$subject $typeClass');
    Logger().i('$day ${readableTime(startTime)} ${readableTime(endTime)}');
    Logger().i('$room  $teacher\n');
  }

  /// Compares the date and time of two lectures.
  int compare(Lecture other) {
    if (day == other.day) {
      return startTime.compareTo(other.startTime);
    } else {
      return day.compareTo(other.day);
    }
  }

  // Compares the endTime of a class with the current time, used in schedule_card
  // Returns the lecture day for comparison
  bool isAfter() {
    final now = DateTime.now();

    if (day > now.weekday - 1 ||
       (day == now.weekday - 1 &&
       (endTime.hour > now.hour ||
       (endTime.hour == now.hour) &&
       (endTime.minute > now.minute)))) {
        return true;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(subject, startTime, endTime, typeClass, room,
      teacher, day, occurrId);

  @override
  bool operator ==(other) =>
      other is Lecture &&
      subject == other.subject &&
      startTime == other.startTime &&
      endTime == other.endTime &&
      typeClass == other.typeClass &&
      room == other.room &&
      teacher == other.teacher &&
      day == other.day &&
      occurrId == other.occurrId;
}
