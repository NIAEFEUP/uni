import 'dart:convert';

import 'package:flutter/foundation.dart';

class Profile {
  String name;
  String email;
  List<Course> courses;

  int get fest_id {
    return courses[0].fest_id;
  }

  String get courseName {
    return courses[0].name;
  }

  int get firstEnrollment {
    return courses[0].firstEnrollment;
  }

  String get currYear {
    return courses[0].currYear;
  }

  Profile({@required this.name, @required this.email, @required this.courses});

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
}

class Course {
  int id;
  int fest_id;
  String name;
  String abreviation;
  String currYear;
  int firstEnrollment;

  Course(
      {int this.id,
      int this.fest_id,
      String this.name,
      String this.abreviation,
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
}
