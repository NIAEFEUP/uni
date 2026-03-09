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
      institutionalEmail: _extractInstitutionalEmail(json),
      rooms: _extractRooms(json),
      isRegent: isRegent,
    );
  }

  static String? _extractInstitutionalEmail(Map<String, dynamic> json) {
    final candidates = [
      json['email_institucional'],
      json['email'],
      json['mail'],
      json['e_mail'],
      json['contacto'],
    ];

    for (final candidate in candidates) {
      final value = candidate?.toString().trim();
      if (value != null && value.isNotEmpty && value.contains('@')) {
        return value;
      }
    }

    return null;
  }

  static List<String> _extractRooms(Map<String, dynamic> json) {
    final candidates = [
      json['salas'],
      json['sala'],
      json['gabinete'],
      json['gabinetes'],
    ];

    final rooms = <String>{};

    for (final candidate in candidates) {
      if (candidate is List) {
        for (final room in candidate) {
          final value = room.toString().trim();
          if (value.isNotEmpty) {
            rooms.add(value);
          }
        }
      } else {
        final value = candidate?.toString().trim();
        if (value != null && value.isNotEmpty) {
          rooms.add(value);
        }
      }
    }

    return rooms.toList();
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
