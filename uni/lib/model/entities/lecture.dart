import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';

part '../../generated/model/entities/lecture.g.dart';


class DateTimeConverter extends JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}

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
    this.blocks,
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
      blocks,
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
      blocks,
      room,
      teacher,
      classNumber,
      occurrId,
    );
  }

  /// Clones a lecture from the api.
  factory Lecture.clone(Lecture lec) {
    return Lecture.fromApi(
      lec.subject,
      lec.typeClass,
      lec.startTime,
      lec.blocks,
      lec.room,
      lec.teacher,
      lec.classNumber,
      lec.occurrId,
    );
  }

  /// Clones a lecture from the html.
  factory Lecture.cloneHtml(Lecture lec) {
    return Lecture.clone(lec);
  }

  String subject;
  String typeClass;
  String room;
  String teacher;
  String classNumber;
  DateTime startTime;
  DateTime endTime;
  int blocks;
  int occurrId;
  Map<String, dynamic> toJson() => _$LectureToJson(this);

  /// Prints the data in this lecture to the [Logger] with an INFO level.
  void printLecture() {
    Logger().i(toString());
  }

  @override
  String toString() {
    return '$subject $typeClass\n$startTime $endTime $blocks blocos\n $room  '
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
        blocks,
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
      blocks == other.blocks &&
      occurrId == other.occurrId;
}
