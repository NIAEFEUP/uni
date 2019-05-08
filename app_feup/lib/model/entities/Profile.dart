import 'dart:convert';

import 'package:tuple/tuple.dart';

class Profile {
  String name;
  String email;
  List<Course> courses;

  Profile({this.name, this.email, this.courses});

  Profile.secConstructor(String name, String email, List<Course> courses) {
    this.name = name;
    this.email = email;
    this.courses = courses;
  }

  static Profile fromResponse(dynamic response) {
    final responseBody = json.decode(response.body);
    List<Course> courses = List<Course>();
    for (var c in responseBody['cursos']) {
      courses.add(Course.fromJson(c));
    }
    return Profile(
        name: responseBody['nome'],
        email: responseBody['email'],
        courses: courses);
  }

  List<Tuple2<String, String>> keymapValues() {
    return [
      Tuple2("name", this.name),
      Tuple2("email", this.email)
    ];
  }
}

class Course {
  int id;
  int fest_id;
  String name;
  String abbreviation;
  String currYear;
  int firstEnrollment;

  Course.secConstructor(int id, int fest_id, String name, String abbreviation, String currYear, int firstEnrollment) {
    this.id = id;
    this.fest_id = fest_id;
    this.name = name;
    this.abbreviation = abbreviation;
    this.currYear = currYear;
    this.firstEnrollment = firstEnrollment;
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
      "firstEnrollment" : firstEnrollment
    };
  }
}
