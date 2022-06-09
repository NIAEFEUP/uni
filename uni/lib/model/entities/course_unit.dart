/// Stores information about a course unit.
class CourseUnit {
  int id;
  String code;
  String abbreviation;
  String name;
  int curricularYear;
  int occurrId;
  String semesterCode;
  String semesterName;
  String type;
  String status;
  String grade;
  String ectsGrade;
  String result;
  num ects;

  CourseUnit(
      {required this.id,
      required this.code,
      required this.abbreviation,
      required this.name,
      required this.curricularYear,
      required this.occurrId,
      required this.semesterCode,
      required this.semesterName,
      required this.type,
      required this.status,
      required this.grade,
      required this.ectsGrade,
      required this.result,
      required this.ects});

  /// Creates a new instance from a JSON object.
  static CourseUnit fromJson(dynamic data) {
    return CourseUnit(
        id: data['ucurr_id'],
        code: data['ucurr_codigo'],
        abbreviation: data['ucurr_sigla'],
        name: data['ucurr_nome'],
        curricularYear: data['ano'],
        occurrId: data['ocorr_id'],
        semesterCode: data['per_codigo'],
        semesterName: data['per_nome'],
        type: data['tipo'],
        status: data['estado'],
        grade: data['resultado_melhor'],
        ectsGrade: data['resultado_ects'],
        result: data['resultado_insc'],
        ects: data['creditos_ects']);
  }
}
