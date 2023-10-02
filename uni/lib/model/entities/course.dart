/// Stores information about a course.
///
/// The information stored is:
/// - Course `id`
/// - The `name` of the course
/// - Abbreviation of the `course`
/// - The course current `year`
/// - The date of the `firstEnrollment`
/// - The course `state`
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

  /// Creates a new instance from a JSON object.
  Course.fromJson(Map<String, dynamic> data)
      : id = (data['cur_id'] ?? 0) as int,
        festId = (data['fest_id'] ?? 0) as int,
        name = data['cur_nome'] as String?,
        currYear = data['ano_curricular'] as String?,
        firstEnrollment = data['fest_a_lect_1_insc'] as int,
        abbreviation = data['abbreviation'] as String?,
        faculty = data['inst_sigla']?.toString().toLowerCase();

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

  /// Converts this course to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fest_id': festId,
      'name': name,
      'abbreviation': abbreviation,
      'currYear': currYear,
      'firstEnrollment': firstEnrollment,
      'state': state,
      'faculty': faculty,
      'currentAverage': currentAverage,
      'finishedEcts': finishedEcts,
    };
  }
}
