import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

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
  String startTime;
  String endTime;
  String typeClass;
  String room;
  String teacher;
  int day;
  int blocks;
  int startTimeSeconds;

  Lecture(String subject, String typeClass, int day, int startTimeSeconds,
      int blocks, String room, String teacher) {
    // this.subject = subject;
    // this.typeClass = typeClass;
    // this.room = room;
    // this.teacher = teacher;
    // this.day = day;
    // this.blocks = blocks;
    // this.startTimeSeconds = startTimeSeconds;

    // this.startTime = (startTimeSeconds ~/ 3600).toString().padLeft(2, '0') +
    //     ':' +
    //     ((startTimeSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    // startTimeSeconds += 60 * 30 * blocks;
    // this.endTime = (startTimeSeconds ~/ 3600).toString().padLeft(2, '0') +
    //     ':' +
    //     ((startTimeSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
  }

  Lecture.secConstructor(String subject, String typeClass, int day,
      String startTime, int blocks, String room, String teacher) {
    this.subject = subject;
    this.typeClass = typeClass;
    this.room = room;
    this.teacher = teacher;
    this.day = day;
    this.blocks = blocks;

    int hour = int.parse(startTime.substring(0, 2));
    int min = int.parse(startTime.substring(3, 5));
    this.startTime =
        hour.toString().padLeft(2, '0') + 'h' + min.toString().padLeft(2, '0');
    min += blocks * 30;
    hour += min ~/ 60;
    min %= 60;
    this.endTime =
        hour.toString().padLeft(2, '0') + 'h' + min.toString().padLeft(2, '0');
  }

  static Lecture clone(Lecture lec) {
    return Lecture(lec.subject, lec.typeClass, lec.day, lec.startTimeSeconds,
        lec.blocks, lec.room, lec.teacher);
  }

  static Lecture cloneHtml(Lecture lec) {
    return Lecture.secConstructor(lec.subject, lec.typeClass, lec.day,
        lec.startTime, lec.blocks, lec.room, lec.teacher);
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'typeClass': typeClass,
      'day': day,
      'startTimeSeconds': startTimeSeconds,
      'blocks': blocks,
      'room': room,
      'teacher': teacher,
    };
  }

  printLecture() {
    Logger().i(subject + ' ' + typeClass);
    Logger().i(dayName[day] +
        ' ' +
        startTime +
        ' ' +
        endTime +
        ' ' +
        blocks.toString() +
        ' blocos');
    Logger().i(room + '  ' + teacher + '\n');
  }

  int compare(Lecture other) {
    if (day == other.day) {
      return startTime.compareTo(other.startTime);
    } else {
      return day.compareTo(other.day);
    }
  }

  @override
  int get hashCode => hashValues(subject, startTime, endTime, typeClass, room,
      teacher, day, blocks, startTimeSeconds);

  @override
  bool operator ==(o) =>
      o is Lecture &&
      this.subject == o.subject &&
      this.startTime == o.startTime &&
      this.endTime == o.endTime &&
      this.typeClass == o.typeClass &&
      this.room == o.room &&
      this.teacher == o.teacher &&
      this.day == o.day &&
      this.blocks == o.blocks &&
      this.startTimeSeconds == o.startTimeSeconds;
}
