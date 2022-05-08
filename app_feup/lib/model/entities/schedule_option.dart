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
}
