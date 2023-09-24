/// Stores information about a course unit.
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
  });

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
  String? schoolYear; // e.g. 2020/2021

  /// Creates a new instance from a JSON object.
  static CourseUnit? fromJson(Map<String, dynamic> data) {
    if (data['ucurr_id'] == null) {
      return null;
    }

    return CourseUnit(
      id: data['ucurr_id'] as int,
      code: data['ucurr_codigo'] as String,
      abbreviation: data['ucurr_sigla'] as String,
      name: data['ucurr_nome'] as String,
      curricularYear: data['ano'] as int,
      occurrId: data['ocorr_id'] as int,
      semesterCode: data['per_codigo'] as String?,
      semesterName: data['per_nome'] as String?,
      type: data['tipo'] as String?,
      status: data['estado'] as String?,
      grade: data['resultado_melhor'] as String?,
      ectsGrade: data['resultado_ects'] as String?,
      result: data['resultado_insc'] as String?,
      ects: data['creditos_ects'] as num?,
      schoolYear: data['a_lectivo'] == null
          ? null
          : toSchoolYear(data['a_lectivo'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'abbreviation': abbreviation,
      'name': name,
      'curricularYear': curricularYear,
      'occurrId': occurrId,
      'semesterCode': semesterCode,
      'semesterName': semesterName,
      'type': type,
      'status': status,
      'grade': grade,
      'ectsGrade': ectsGrade,
      'result': result,
      'ects': ects,
      'schoolYear': schoolYear,
    };
  }

  bool enrollmentIsValid() {
    return status == 'V' || status == 'C';
  }

  static String toSchoolYear(int year) {
    return '$year/${year + 1}';
  }
}
