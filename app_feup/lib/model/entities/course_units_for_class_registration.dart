import 'package:uni/model/entities/course_unit.dart';

class CourseUnitsForClassRegistration {
  List<CourseUnit> selected;
  CourseUnitsForClassRegistration({this.selected});

  bool contains(CourseUnit courseUnit) {
    for (CourseUnit selectedCourseUnit in selected) {
      if (selectedCourseUnit.id == courseUnit.id) {
        return true;
      }
    }
    return false;
  }

  void select(CourseUnit courseUnit) {
    selected.add(courseUnit);
  }

  void unselect(CourseUnit courseUnit) {
    selected = selected
        .where((selectedCourseUnit) => selectedCourseUnit.id != courseUnit.id)
        .toList();
  }
}
