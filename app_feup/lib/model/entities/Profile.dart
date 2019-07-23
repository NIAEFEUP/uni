import 'dart:convert';

import 'package:tuple/tuple.dart';

import 'Course.dart';

class Profile {
  String name;
  String email;
  List<Course> courses;
  String printBalance;
  String feesBalance;
  String feesLimit;

  Profile({this.name, this.email, this.courses});

  Profile.secConstructor(String name, String email, List<Course> courses, String printBalance, String feesBalance, String feesLimit) {
    this.name = name;
    this.email = email;
    this.courses = courses;
    this.printBalance = printBalance;
    this.feesBalance = feesBalance;
    this.feesLimit = feesLimit;
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
