import 'dart:convert';

import 'package:http/http.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

/// Stores information about the user's profile.
@Entity()
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
    var responseBody = json.decode(response.body);
    responseBody = responseBody as Map<String, dynamic>;
    final courses = <Course>[];
    for (final c in responseBody['cursos'] as List<dynamic>) {
      courses.add(Course.fromJson(c as Map<String, dynamic>));
    }

    return Profile(
      name: responseBody['nome'] as String? ?? '',
      email: responseBody['email'] as String? ?? '',
      courses: courses,
    );
  }

  @Id()
  int? id;
  final String name;
  final String email;
  String printBalance;
  String feesBalance;
  DateTime? feesLimit;
  @Transient()
  List<Course> courses;
  @Transient()
  List<CourseUnit> courseUnits;

  /// Returns a list with two tuples: the first tuple contains the user's name
  /// and the other one contains the user's email.
  List<(String, String)> keymapValues() {
    return [
      ('name', name),
      ('email', email),
      ('printBalance', printBalance),
      ('feesBalance', feesBalance),
      (
        'feesLimit',
        feesLimit != null ? feesLimit!.toIso8601String() : '',
      ),
    ];
  }
}
