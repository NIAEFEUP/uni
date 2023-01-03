import 'package:logger/logger.dart';

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
  String typeClass;
  String room;
  String teacher;
  String classNumber;
  DateTime startTime;
  DateTime endTime;
  int blocks;
  int occurrId;

  /// Creates an instance of the class [Lecture].
  Lecture(
      this.subject,
      this.typeClass,
      this.startTime,
      this.endTime,
      this.blocks,
      this.room,
      this.teacher,
      this.classNumber,
      this.occurrId);

  factory Lecture.fromApi(
      String subject,
      String typeClass,
      DateTime startTime,
      int blocks,
      String room,
      String teacher,
      String classNumber,
      int occurrId) {
    final endTime = startTime.add(Duration(seconds:60 * 30 * blocks));
    final lecture = Lecture(
        subject,
        typeClass,
        startTime,
        endTime,
        blocks,
        room,
        teacher,
        classNumber,
        occurrId);
    return lecture;
  }

  factory Lecture.fromHtml(
      String subject,
      String typeClass,
      DateTime day,
      String startTime,
      int blocks,
      String room,
      String teacher,
      String classNumber,
      int occurrId) {
    final startTimeHours = int.parse(startTime.substring(0, 2));
    final startTimeMinutes = int.parse(startTime.substring(3, 5));
    final endTimeHours =
        (startTimeMinutes + (blocks * 30)) ~/ 60 + startTimeHours;
    final endTimeMinutes = (startTimeMinutes + (blocks * 30)) % 60;
    return Lecture(
        subject,
        typeClass,
        day.add(Duration(hours: startTimeHours, minutes: startTimeMinutes)),
        day.add(Duration(hours: startTimeMinutes+endTimeHours, minutes: startTimeMinutes+endTimeMinutes)),
        blocks,
        room,
        teacher,
        classNumber,
        occurrId);
  }

  /// Clones a lecture from the api.
  static Lecture clone(Lecture lec) {
    return Lecture.fromApi(
        lec.subject,
        lec.typeClass,
        lec.startTime,
        lec.blocks,
        lec.room,
        lec.teacher,
        lec.classNumber,
        lec.occurrId);
  }

  /// Clones a lecture from the html.
  static Lecture cloneHtml(Lecture lec) {
    return Lecture.clone(lec);
  }

  /// Converts this lecture to a map.
  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'typeClass': typeClass,
      'startDateTime': startTime.toIso8601String(),
      'blocks': blocks,
      'room': room,
      'teacher': teacher,
      'classNumber': classNumber,
      'occurrId': occurrId
    };
  }

  /// Prints the data in this lecture to the [Logger] with an INFO level.
  printLecture() {
    Logger().i('$subject $typeClass');
    //iso8601 states that weekdays start from 1
    Logger().i('${dayName[startTime.weekday-1]} $startTime $endTime $blocks blocos');
    Logger().i('$room  $teacher\n');
  }

  /// Compares the date and time of two lectures.
  int compare(Lecture other) {
    return startTime.compareTo(other.startTime);
  }

  @override
  int get hashCode => Object.hash(subject, startTime, endTime, typeClass, room,
      teacher, startTime, blocks, occurrId);

  @override
  bool operator ==(other) =>
      other is Lecture &&
      subject == other.subject &&
      startTime == other.startTime &&
      endTime == other.endTime &&
      typeClass == other.typeClass &&
      room == other.room &&
      teacher == other.teacher &&
      blocks == other.blocks &&
      occurrId == other.occurrId &&
      startTime == other.startTime;
}
