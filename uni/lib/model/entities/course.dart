import 'package:collection/collection.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

/// Stores information about a course.
class Course {
  Course({
    required this.festId,
    this.name,
    this.abbreviation,
    this.currYear,
    this.faculty,
    this.courseUnits = const [],
  });

  double get average {
    final grades = courseUnits
        .map((e) => e.grade)
        .where((element) => element != null)
        .toList();
    return grades.isEmpty
        ? 0
        : grades.reduce((a, b) => a! + b!)! / grades.length;
  }

  double get performedECTS {
    final ects = courseUnits
        .where((c) => c.grade != null && c.grade! >= 10)
        .map((e) => e.ects?.toDouble())
        .whereNotNull()
        .toList();
    return ects.sum;
  }

  static Course? fromJson(Map<String, dynamic> data) {
    if (data['fest_id'] == null || data['fest_id'] == 0) {
      return null;
    }

    return Course(
      festId: data['fest_id'] as int,
      currYear: int.tryParse(data['ano_curricular'] as String? ?? ''),
      name: data['cur_nome'] as String?,
      abbreviation: data['abbreviation'] as String?,
      faculty: data['inst_sigla']?.toString().toLowerCase(),
      courseUnits: data['inscricoes'] != null
          ? (data['inscricoes'] as List<dynamic>)
              .map((e) => CourseUnit.fromJson(e as Map<String, dynamic>))
              .whereNotNull()
              .toList()
          : [],
    );
  }

  final int festId;
  final String? name;
  final String? abbreviation;
  final int? currYear;
  final String? faculty;
  List<CourseUnit> courseUnits = [];

  /// Converts this course to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': festId,
      'fest_id': festId,
      'name': name,
      'abbreviation': abbreviation,
      'currYear': currYear,
      'faculty': faculty,
    };
  }
}
