import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';

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
}
