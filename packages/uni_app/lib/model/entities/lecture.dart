import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uni/model/converters/date_time_converter.dart';

part '../../generated/model/entities/lecture.g.dart';

/// Stores information about a lecture.
@DateTimeConverter()
@JsonSerializable()
@Entity()
class Lecture {
  /// Creates an instance of the class [Lecture].
  Lecture(
    this.acronym,
    this.subject,
    this.typeClass,
    this.startTime,
    this.endTime,
    this.room,
    this.teacher,
    this.teacherName,
    this.teacherId,
    this.classNumber,
    this.occurrId,
  );

  factory Lecture.fromJson(Map<String, dynamic> json) =>
      _$LectureFromJson(json);

  factory Lecture.fromApi(
    String acronym,
    String subject,
    String typeClass,
    DateTime startTime,
    int blocks,
    String room,
    String teacher,
    String teacherName,
    int teacherId,
    String classNumber,
    int occurrId,
  ) {
    final endTime = startTime.add(Duration(minutes: 30 * blocks));
    final lecture = Lecture(
      acronym,
      subject,
      typeClass,
      startTime,
      endTime,
      room,
      teacher,
      teacherName,
      teacherId,
      classNumber,
      occurrId,
    );
    return lecture;
  }

  @Id()
  int? uniqueId;

  String acronym;
  String subject;
  String typeClass;
  String room;
  String teacher;
  String teacherName;
  int teacherId;
  String classNumber;
  DateTime startTime;
  DateTime endTime;
  int occurrId;

  Map<String, dynamic> toJson() => _$LectureToJson(this);

  @override
  String toString() {
    return '$acronym \n$subject $typeClass\n$startTime $endTime\n $room  '
        '$teacher\n';
  }

  /// Compares the date and time of two lectures.
  int compare(Lecture other) {
    return startTime.compareTo(other.startTime);
  }

  @override
  int get hashCode => Object.hash(
        acronym,
        subject,
        startTime,
        endTime,
        typeClass,
        room,
        teacher,
        teacherName,
        teacherId,
        startTime,
        occurrId,
      );

  @override
  bool operator ==(Object other) =>
      other is Lecture &&
      acronym == other.acronym &&
      subject == other.subject &&
      startTime == other.startTime &&
      endTime == other.endTime &&
      typeClass == other.typeClass &&
      room == other.room &&
      teacher == other.teacher &&
      teacherName == other.teacherName &&
      teacherId == other.teacherId &&
      occurrId == other.occurrId;
}
