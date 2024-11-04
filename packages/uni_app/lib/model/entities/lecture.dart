import 'package:json_annotation/json_annotation.dart';
import 'package:uni/model/entities/reference.dart';

part '../../generated/model/entities/lecture.g.dart';

/// Stores information about a lecture.
@DateTimeConverter()
@JsonSerializable()
class Lecture {
  /// Creates an instance of the class [Lecture].
  Lecture(
    this.subject,
    this.typeClass,
    this.startTime,
    this.endTime,
    this.room,
    this.teacher,
    this.classNumber,
    this.occurrId,
  );

  factory Lecture.fromJson(Map<String, dynamic> json) =>
      _$LectureFromJson(json);

  factory Lecture.fromApi(
    String subject,
    String typeClass,
    DateTime startTime,
    int blocks,
    String room,
    String teacher,
    String classNumber,
    int occurrId,
  ) {
    final endTime = startTime.add(Duration(minutes: 30 * blocks));
    final lecture = Lecture(
      subject,
      typeClass,
      startTime,
      endTime,
      room,
      teacher,
      classNumber,
      occurrId,
    );
    return lecture;
  }

  factory Lecture.fromHtml(
    String subject,
    String typeClass,
    DateTime day,
    String startTimeString,
    int blocks,
    String room,
    String teacher,
    String classNumber,
    int occurrId,
  ) {
    final startTimeList = startTimeString.split(':');
    final startTime = day.add(
      Duration(
        hours: int.parse(startTimeList[0]),
        minutes: int.parse(startTimeList[1]),
      ),
    );
    final endTime = startTime.add(Duration(minutes: 30 * blocks));
    return Lecture(
      subject,
      typeClass,
      startTime,
      endTime,
      room,
      teacher,
      classNumber,
      occurrId,
    );
  }

  String subject;
  String typeClass;
  String room;
  String teacher;
  String classNumber;
  DateTime startTime;
  DateTime endTime;
  int occurrId;
  Map<String, dynamic> toJson() => _$LectureToJson(this);

  @override
  String toString() {
    return '$subject $typeClass\n$startTime $endTime\n $room  '
        '$teacher\n';
  }

  /// Compares the date and time of two lectures.
  int compare(Lecture other) {
    return startTime.compareTo(other.startTime);
  }

  @override
  int get hashCode => Object.hash(
        subject,
        startTime,
        endTime,
        typeClass,
        room,
        teacher,
        startTime,
        occurrId,
      );

  @override
  bool operator ==(Object other) =>
      other is Lecture &&
      subject == other.subject &&
      startTime == other.startTime &&
      endTime == other.endTime &&
      typeClass == other.typeClass &&
      room == other.room &&
      teacher == other.teacher &&
      occurrId == other.occurrId;
}
