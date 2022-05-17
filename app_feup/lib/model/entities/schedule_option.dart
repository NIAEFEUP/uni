import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:collection/collection.dart';

class ScheduleOption {
  int id;
  String name;
  Map<String, String> classesSelected;
  int preference;

  ScheduleOption({this.id, this.name, this.classesSelected, this.preference});

  ScheduleOption.generate(
      int id, String name, Map<String, String> classesSelected, int preference
      ) {
    this.id = id;
    this.name = name;
    this.classesSelected = classesSelected;
    this.preference = preference;
  }

  List<Lecture> getLectures(int day, List<CourseUnit> courseUnits) {
    final List<Lecture> lectures = [];

    this.classesSelected.forEach((abbreviation, value) {
      final CourseUnit courseUnit =
        courseUnits.firstWhereOrNull(
                (cUnit) => cUnit.abbreviation == abbreviation
        );
      final String name =
        this.classesSelected[courseUnit.abbreviation];
      final CourseUnitClass courseUnitClass =
        courseUnit.classes.firstWhereOrNull((cUClass) => cUClass.name == name);

      lectures.addAll(
          courseUnitClass
              .lectures
              .where((lecture) => lecture.day == day)
      );

    });

    lectures.sort((a, b) => a.startTime.compareTo(b.startTime));
    return lectures;
  }

  static List<bool> getDiscontinuities(List<Lecture> lectures) {
    final List<bool> hasDiscontinuity = List.filled(lectures.length, false);
    for (int i = 1; i < lectures.length; i++) {
      if (lectures[i].startTime.compareTo(lectures[i - 1].endTime) == 1) {
        hasDiscontinuity[i] = true;
      }
    }
    return hasDiscontinuity;
  }

  static List<bool> getCollisions(List<Lecture> lectures) {
    final List<bool> hasCollisions = List.filled(lectures.length, false);
    for (int i = 0; i < lectures.length; i++) {
      for (int j = 0; j < lectures.length; j++) {
        if (i != j && lectures[i].collidesWith(lectures[j])) {
          hasCollisions[i] = true;
          break;
        }
      }
    }
    return hasCollisions;
  }

  bool hasCollisions(int day, List<CourseUnit> courseUnits) {
    final List<Lecture> lectures = this.getLectures(day, courseUnits);
    for (int i = 0; i < lectures.length; i++) {
      for (int j = 0; j < lectures.length; j++) {
        if (i != j && lectures[i].collidesWith(lectures[j])) {
          return true;
        }
      }
    }
    return false;
  }
}
