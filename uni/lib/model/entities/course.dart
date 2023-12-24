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
  Course({
    required this.id,
    this.festId = 0,
    this.name,
    this.abbreviation,
    this.currYear,
    this.firstEnrollment,
    this.state,
    this.faculty,
    this.finishedEcts,
    this.currentAverage,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  @JsonKey(name: 'cur_id')
  final int id;
  @JsonKey(name: 'fest_id')
  final int? festId;
  @JsonKey(name: 'cur_nome')
  final String? name;
  @JsonKey(name: 'abbreviation')
  final String? abbreviation;
  @JsonKey(name: 'ano_curricular')
  final String? currYear;
  @JsonKey(name: 'fest_a_lect_1_insc')
  final int? firstEnrollment;
  @JsonKey(name: 'inst_sigla')
  final String? faculty;
  String? state;
  num? finishedEcts;
  num? currentAverage;
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
