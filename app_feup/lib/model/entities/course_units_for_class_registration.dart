import 'package:uni/model/entities/course_unit.dart';

class CourseUnitsForClassRegistration {
  List<CourseUnit> selected;
  List<CourseUnit> allCourseUnits;

  CourseUnitsForClassRegistration(
      List<String> selectedAbrv,
      List<CourseUnit> courseUnits
      ) {

    final List<CourseUnit> newSelected = List.empty(growable: true);

    for (String courseUnitAbrv in selectedAbrv) {

      final CourseUnit selectedCourseUnit = courseUnits.firstWhere(
              (element) => element.abbreviation == courseUnitAbrv
      );

      if (selectedCourseUnit != null) newSelected.add(selectedCourseUnit);
    }

    this.selected = newSelected;
    this.allCourseUnits = courseUnits;

  }

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
        .where((selectedCourseUnit) =>
    selectedCourseUnit.id != courseUnit.id)
        .toList();
  }
}
