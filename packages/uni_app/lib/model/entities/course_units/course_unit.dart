import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';

part '../../../generated/model/entities/course_units/course_unit.g.dart';

/// Stores information about a course unit.
@JsonSerializable()
@Entity()
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
    this.festId,
    String? dbOccurences,
    Map<String, int>? occurences,
  }) {
    // If the constructor receives a Map (e.g., from fromJson), save it.
    // Otherwise, if it receives a DB string, keep that.
    if (occurences != null) {
      this.occurences = occurences;
    } else {
      this.dbOccurences = dbOccurences;
    }
  }

  factory CourseUnit.fromJson(Map<String, dynamic> json) =>
      _$CourseUnitFromJson(json);

  @JsonKey(name: 'ucurr_id')
  @Id(assignable: true)
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
  double? ects;
  @JsonKey(name: 'fest_id') // Course id
  int? festId;
  String? schoolYear;

  // --- The Database/JSON bridge for occurences ---

  @JsonKey(ignore: true)
  String? dbOccurences;

  @Transient()
  Map<String, int>? get occurences {
    if (dbOccurences == null || dbOccurences!.trim().isEmpty) {
      return null;
    }

    final decoded = jsonDecode(dbOccurences!) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  set occurences(Map<String, int>? value) {
    dbOccurences = value != null ? jsonEncode(value) : null;
  }

  Map<String, dynamic> toJson() => _$CourseUnitToJson(this);

  bool enrollmentIsValid() {
    return status == 'V' || status == 'C';
  }

  static String toSchoolYear(int year) {
    return '$year/${year + 1}';
  }
}
