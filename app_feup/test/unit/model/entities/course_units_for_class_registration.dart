import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_units_for_class_registration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CourseUnitsForClassRegistration', () {
    test('Create from abbreviations and list of course units', () {
      final CourseUnit c1 = CourseUnit(abbreviation: 'A');
      final CourseUnit c2 = CourseUnit(abbreviation: 'B');
      final CourseUnit c3 = CourseUnit(abbreviation: 'C');
      final CourseUnit c4 = CourseUnit(abbreviation: 'D');

      final CourseUnitsForClassRegistration selected =
          CourseUnitsForClassRegistration(
            ['B', 'D', 'E'],
            [
              c1, c2, c3, c4
            ],
          );

      expect(selected.countSelected, 2);
      expect(selected.contains(c2), true);
      expect(selected.contains(c4), true);
    });

    test('Add course unit', () {
      final CourseUnit c1 = CourseUnit(abbreviation: 'A');

      final CourseUnitsForClassRegistration selected =
      CourseUnitsForClassRegistration([], []);

      expect(selected.isEmpty, true);
      selected.select(c1);
      expect(selected.isNotEmpty, true);
      expect(selected.selected, [c1]);
    });

    test('Remove course unit', () {
      final CourseUnit c1 = CourseUnit(abbreviation: 'A');
      final CourseUnit c2 = CourseUnit(abbreviation: 'B');
      final CourseUnit c3 = CourseUnit(abbreviation: 'C');
      final CourseUnit c4 = CourseUnit(abbreviation: 'D');

      final CourseUnitsForClassRegistration selected =
      CourseUnitsForClassRegistration(
        ['A', 'B', 'C', 'D'],
        [
          c1, c2, c3, c4
        ],
      );

      selected.unselect(c3);
      expect(selected.countSelected, 3);
      expect(selected.contains(c3), false);
    });

    test('Add course unit twice', () {
      final CourseUnit c1 = CourseUnit(abbreviation: 'A');

      final CourseUnitsForClassRegistration selected =
      CourseUnitsForClassRegistration([], []);

      selected.select(c1);
      selected.select(c1);
      expect(selected.countSelected, 1);
    });
  });
}
