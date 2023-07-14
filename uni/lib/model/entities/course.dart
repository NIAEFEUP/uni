import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

/// Stores information about a course.
///
/// The information stored is:
/// - Course `id`
/// - The `name` of the course
/// - Abbreviation of the `course`
/// - The course current `year`
/// - The date of the `firstEnrollment`
/// - The course `state`
@JsonSerializable()
class Course {
  final int id;
  final int? festId;
  final String? name;
  final String? abbreviation;
  final String? currYear;
  final int? firstEnrollment;
  final String? faculty;
  String? state;
  num? finishedEcts;
  num? currentAverage;

  Course(
      {required this.id,
      this.festId = 0,
      this.name,
      this.abbreviation,
      this.currYear,
      this.firstEnrollment,
      this.state,
      this.faculty,
      this.finishedEcts,
      this.currentAverage});

  factory Course.fromJson(Map<String,dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
