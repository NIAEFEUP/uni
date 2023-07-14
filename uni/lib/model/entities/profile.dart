import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/course.dart';

part 'profile.g.dart';

/// Stores information about the user's profile.
@JsonSerializable()
class Profile {
  final String name;
  final String email;
  late List<Course> courses;
  final String printBalance;
  final String feesBalance;
  final DateTime? feesLimit;

  Profile(
      {this.name = '',
      this.email = '',
      courses,
      this.printBalance = '',
      this.feesBalance = '',
      this.feesLimit})
      : courses = courses ?? [];

  factory Profile.fromJson(Map<String,dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  /// Returns a list with two tuples: the first tuple contains the user's name
  /// and the other one contains the user's email.
  List<Tuple2<String, String>> keymapValues() {
    return [
      Tuple2('name', name),
      Tuple2('email', email),
    ];
  }
}
