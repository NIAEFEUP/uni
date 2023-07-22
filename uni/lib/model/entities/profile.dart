import 'dart:convert';
import 'package:http/http.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

/// Stores information about the user's profile.
class Profile {
  Profile({
    this.name = '',
    this.email = '',
    List<Course>? courses,
    this.printBalance = '',
    this.feesBalance = '',
    this.feesLimit,
  })  : courses = courses ?? [],
        courseUnits = [];

  /// Creates a new instance from a JSON object.
  factory Profile.fromResponse(Response response) {
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    final courses = <Course>[];
    for (final c in responseBody['cursos'] as Iterable<Map<String, dynamic>>) {
      courses.add(Course.fromJson(c));
    }

    return Profile(
      name: responseBody['nome'] as String,
      email: responseBody['email'] as String,
      courses: courses,
    );
  }

  final String name;
  final String email;
  final String printBalance;
  final String feesBalance;
  final DateTime? feesLimit;
  List<Course> courses;
  List<CourseUnit> courseUnits;

  /// Returns a list with two tuples: the first tuple contains the user's name
  /// and the other one contains the user's email.
  List<Tuple2<String, String>> keymapValues() {
    return [
      Tuple2('name', name),
      Tuple2('email', email),
    ];
  }
}
