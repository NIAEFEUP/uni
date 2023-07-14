import 'package:json_annotation/json_annotation.dart';

part 'course_unit.g.dart';

/// Stores information about a course unit.
@JsonSerializable()
class CourseUnit {
  int id;
  String code;
  String abbreviation;
  String name;
  int? curricularYear;
  int occurrId;
  String? semesterCode;
  String? semesterName;
  String? type;
  String? status;
  String? grade;
  String? ectsGrade;
  String? result;
  num? ects;
  String? schoolYear;

  CourseUnit(
      {this.id = 0,
      this.code = '',
      required this.abbreviation,
      required this.name,
      this.curricularYear,
      required this.occurrId,
      this.semesterCode,
      this.semesterName,
      this.type,
      this.status,
      this.grade,
      this.ectsGrade,
      this.result,
      this.ects,
      this.schoolYear});

  factory CourseUnit.fromJson(Map<String,dynamic> json) => _$CourseUnitFromJson(json);
  Map<String, dynamic> toJson() => _$CourseUnitToJson(this);

  bool enrollmentIsValid() {
    return status == 'V';
  }
}
