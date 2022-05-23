import 'package:uni/model/entities/course_unit.dart';

class CourseUnitsForClassRegistration {
  Set<CourseUnit> _selected;

  CourseUnitsForClassRegistration(
      List<String> selectedAbrv,
      List<CourseUnit> courseUnits
      ) {

    final Set<CourseUnit> newSelected = Set();

    for (String courseUnitAbrv in selectedAbrv) {
      final CourseUnit selectedCourseUnit = courseUnits.firstWhere(
              (element) => element.abbreviation == courseUnitAbrv
      );

      if (selectedCourseUnit != null) newSelected.add(selectedCourseUnit);
    }

    this._selected = newSelected;
  }

  List<CourseUnit> get selected {
    final List<CourseUnit> list = _selected.toList();
    list.sort((v1, v2) => v1.name.compareTo(v2.name));
    return list;
  }
  bool get isNotEmpty => this._selected.isNotEmpty;
  bool get isEmpty => this._selected.isEmpty;
  int get countSelected => this._selected.length;

  bool contains(CourseUnit courseUnit) => _selected.contains(courseUnit);

  void select(CourseUnit courseUnit) {
    _selected.add(courseUnit);
  }

  void unselect(CourseUnit courseUnit) {
    _selected.remove(courseUnit);
  }
}
