import 'package:json_annotation/json_annotation.dart';

part '../../../generated/model/entities/course_units/course_unit.g.dart';

/// Stores information about a course unit.
@JsonSerializable()
class CourseUnit {
  CourseUnit({
    required this.abbreviation,
    required this.name,
    required this.occurrId,
    this.id = 0,
    this.code = '',
    this.curricularYear,
    this.semesterCode,
    this.semesterName,
    this.type,
    this.status,
    this.grade,
    this.ectsGrade,
    this.result,
    this.ects,
    this.schoolYear,
  }); // e.g. 2020/2021

  factory CourseUnit.fromJson(Map<String, dynamic> json) =>
      _$CourseUnitFromJson(json);

  @JsonKey(name: 'ucurr_id')
  int? id;
  @JsonKey(name: 'ucurr_codigo')
  String code;
  @JsonKey(name: 'ucurr_sigla')
  String abbreviation;
  @JsonKey(name: 'ucurr_nome')
  String name;
  @JsonKey(name: 'ano')
  int? curricularYear;
  @JsonKey(name: 'ocorr_id')
  int? occurrId;
  @JsonKey(name: 'per_codigo')
  String? semesterCode;
  @JsonKey(name: 'per_nome')
  String? semesterName;
  @JsonKey(name: 'tipo')
  String? type;
  @JsonKey(name: 'estado')
  String? status;
  @JsonKey(name: 'resultado_melhor')
  String? grade;
  @JsonKey(name: 'resultado_ects')
  String? ectsGrade;
  @JsonKey(name: 'resultado_insc')
  String? result;
  @JsonKey(name: 'creditos_ects')
  num? ects;
  String? schoolYear;
  Map<String, dynamic> toJson() => _$CourseUnitToJson(this);

  bool enrollmentIsValid() {
    return status == 'V' || status == 'C';
  }

  static String toSchoolYear(int year) {
    return '$year/${year + 1}';
  }
}
