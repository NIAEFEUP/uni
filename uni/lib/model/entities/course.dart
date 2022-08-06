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

  /// Creates a new instance from a JSON object.
  static Course fromJson(dynamic data) {
    return Course(
        id: data['cur_id'],
        festId: data['fest_id'],
        name: data['cur_nome'],
        currYear: data['ano_curricular'],
        firstEnrollment: data['fest_a_lect_1_insc'],
        abbreviation: 'abbreviation',
        faculty: data['inst_sigla'].toString().toLowerCase());
  }

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
