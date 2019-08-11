class Course {
  final int id;
  final int fest_id;
  final String name;
  final String abbreviation;
  final String currYear;
  final int firstEnrollment;
  final String state;

  Course(
      {int this.id,
        int this.fest_id,
        String this.name,
        String this.abbreviation,
        String this.currYear,
        int this.firstEnrollment,
        String this.state = ""});

  static Course fromJson(dynamic data) {
    return Course(
        id: data['cur_id'],
        fest_id: data['fest_id'],
        name: data['cur_nome'],
        currYear: data['ano_curricular'],
        firstEnrollment: data['fest_a_lect_1_insc']);
  }

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "fest_id" : fest_id,
      "name" : name,
      "abbreviation" : abbreviation,
      "currYear" : currYear,
      "firstEnrollment" : firstEnrollment,
      "state": state
    };
  }
}