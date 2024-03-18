import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Sheet {
  Sheet({
    required this.professors,
    required this.content,
    required this.evaluation,
    required this.regents,
  });
  List<Professor> professors;
  List<Professor> regents;
  String content;
  String evaluation;
}

class Professor {
  Professor({
    required this.code,
    required this.name,
    required this.classes,
    this.picture,
  });

  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      code: json['codigo'].toString(),
      name: json['nome'].toString(),
      classes: [],
    );
  }

  File? picture;
  String code;
  String name;
  List<String> classes;

  @override
  bool operator ==(Object other) {
    if (other is Professor) {
      return other.code == code;
    }
    return false;
  }

  @override
  int get hashCode => code.hashCode;
}
