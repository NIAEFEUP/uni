import 'dart:io';

import 'package:uni/controller/parsers/parser_course_unit_info.dart';

class Sheet {
  Sheet({
    required this.professors,
    required this.content,
    required this.evaluation,
    required this.frequency,
    required this.books,
  });
  List<Professor> professors;
  String content;
  String evaluation;
  String frequency;
  List<Book> books;
}

class Book {
  Book({required this.title, required this.isbn});

  String title;
  String isbn;
}

class Professor {
  Professor({
    required this.code,
    required this.name,
    required this.classes,
    this.institutionalEmail,
    this.rooms = const [],
    this.picture,
    this.isRegent = false,
  });

  factory Professor.fromJson(
    Map<String, dynamic> json, {
    List<String> classes = const [],
    bool isRegent = false,
  }) {
    return Professor(
      code: (json['codigo'] ?? json['doc_codigo']).toString(),
      name: shortName(json['nome'].toString()),
      classes: classes,
      isRegent: isRegent,
    );
  }

  File? picture;
  String code;
  String name;
  List<String> classes;
  String? institutionalEmail;
  List<String> rooms;
  bool isRegent;

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
