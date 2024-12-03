import 'package:json_annotation/json_annotation.dart';

part '../../generated/model/entities/course.g.dart';

/// Stores information about a course.
///
/// The information stored is:
/// - Course `id`
/// - The `name` of the course
/// - Abbreviation of the `course`
/// - The course current `year`
/// - The date of the `firstEnrollment`
/// - The course `state`
@JsonSerializable(createFactory: false)
class Course {
  Course({
    this.id,
    this.festId,
    this.name,
    this.abbreviation,
    this.currYear,
    this.firstEnrollment,
    this.state,
    this.faculty,
    this.finishedEcts,
    this.currentAverage,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var name = json['cur_nome'] as String?;
    if (name == null || name.isEmpty) {
      name = json['fest_tipo_descr'] as String?;
    }

    return Course(
      id: json['cur_id'] as int?,
      festId: json['fest_id'] as int?,
      name: name,
      abbreviation: json['abbreviation'] as String?,
      currYear: json['ano_curricular'] as String?,
      firstEnrollment: json['fest_a_lect_1_insc'] as int?,
      state: json['state'] as String?,
      faculty: json['inst_sigla'].toString().toLowerCase(),
      finishedEcts: json['finishedEcts'] as num?,
      currentAverage: json['currentAverage'] as num?,
    );
  }
  @JsonKey(name: 'cur_id')
  final int? id;
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
