import 'dart:convert';

import 'package:tuple/tuple.dart';

import 'Course.dart';

class Profile {
  final String name;
  final String email;
  List<Course> courses;
  final String printBalance;
  final String feesBalance;
  final String feesLimit;

  Profile({
    this.name = "",
    this.email = "",
    this.courses,
    this.printBalance = "",
    this.feesBalance = "",
    this.feesLimit = ""});

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
