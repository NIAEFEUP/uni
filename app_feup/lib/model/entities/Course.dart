class Course {
  int id;
  int fest_id;
  String name;
  String abbreviation;
  String currYear;
  int firstEnrollment;
  String state = "";

  Course.secConstructor(int id, int fest_id, String name, String abbreviation, String currYear, int firstEnrollment, String state) {
    this.id = id;
    this.fest_id = fest_id;
    this.name = name;
    this.abbreviation = abbreviation;
    this.currYear = currYear;
    this.firstEnrollment = firstEnrollment;
    this.state = state;
  }

  Course(
      {int this.id,
        int this.fest_id,
        String this.name,
        String this.abbreviation,
        String this.currYear,
        int this.firstEnrollment});

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