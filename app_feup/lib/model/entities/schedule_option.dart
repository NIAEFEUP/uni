import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/lecture.dart';

class ScheduleOption {
  int id;
  String name;
  Map<CourseUnit, CourseUnitClass> classesSelected;

  ScheduleOption({this.id, this.name, this.classesSelected});

  ScheduleOption.newInstance() {
    this.id = 5; // TODO: generate unique id
    this.name = 'Novo Horário';
    this.classesSelected = Map<CourseUnit, CourseUnitClass>();
  }

  List<Lecture> getLectures(int day) {
    final List<Lecture> lectures = [];
    for (final value in this.classesSelected.values) {
      lectures.addAll(value.lectures.where((lecture) => lecture.day == day));
    }
    lectures.sort((a, b) => a.startTime.compareTo(b.startTime));
    return lectures;
  }

  bool hasCollisions(int day) {
    final List<Lecture> lectures = this.getLectures(day);
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
