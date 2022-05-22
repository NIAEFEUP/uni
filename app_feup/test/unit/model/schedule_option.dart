import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/course_unit_class.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/schedule_option.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LectureMock extends Mock implements Lecture {
  @override
  int day;
  @override
  String startTime;

  String collisionKey; // Mock simplification of collision logic

  LectureMock(this.day, this.startTime, this.collisionKey);

  @override
  bool collidesWith(Lecture other) {
    return this.collisionKey == (other as LectureMock).collisionKey;
  }
}

void main() {
  group('ScheduleOption', () {
    test('Get lectures', () {
      final Map<String, String> classes = Map();
      final CourseUnitClass courseUnitClass1 = CourseUnitClass(
        name: '3LEIC01',
          lectures: [
        LectureMock(0, '10h00', 'A'),
        LectureMock(1, '09h30', 'B'),
      ]);
      final CourseUnitClass courseUnitClass2 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(1, '08h30', 'C'),
      ]);

      final CourseUnit courseUnit1 = CourseUnit(
          abbreviation: 'ABC',
          classes: [courseUnitClass1]
      );
      final CourseUnit courseUnit2 = CourseUnit(
          abbreviation: 'BAC',
        classes: [courseUnitClass2]
      );

      classes[courseUnit1.abbreviation] = courseUnitClass1.name;
      classes[courseUnit2.abbreviation] = courseUnitClass2.name;

      final ScheduleOption instance = ScheduleOption(
          id: 1,
          name: 'Horário Teste',
          classesSelected: classes,
          preference: 0,
      );

      final List<CourseUnit> courseUnits = [courseUnit1, courseUnit2];
      expect(instance.getLectures(0, courseUnits).length, 1);
      final List<Lecture> day1Lectures = instance.getLectures(1, courseUnits);
      expect(day1Lectures.length, 2);
      // Check order of lectures
      expect(day1Lectures[0].startTime, '08h30');
      expect(day1Lectures[1].startTime, '09h30');
      for (int i = 2; i < 7; i++) {
        expect(instance.getLectures(i, courseUnits).length, 0);
      }
    });

    test('Change class', () {
      final Map<String, String> classes = Map();
      final CourseUnitClass courseUnitClass1 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(0, '10h00', 'A'),
        LectureMock(1, '09h30', 'B'),
      ]);
      final CourseUnitClass courseUnitClass2 = CourseUnitClass(
          name: '3LEIC02',
          lectures: [
        LectureMock(1, '08h30', 'C'),
      ]);

      final CourseUnit courseUnit1 = CourseUnit(
          abbreviation: 'ABC',
        classes: [courseUnitClass1, courseUnitClass2]
      );

      classes[courseUnit1.abbreviation] = courseUnitClass1.name;
      classes[courseUnit1.abbreviation] = courseUnitClass2.name;

      final ScheduleOption instance = ScheduleOption(classesSelected: classes);
      final List<CourseUnit> courseUnits = [courseUnit1];
      for (int i = 0; i < 7; i++) {
        if (i != 1) {
          expect(instance.getLectures(i, courseUnits).length, 0);
        } else {
          expect(instance.getLectures(i, courseUnits).length, 1);
        }
      }
    });

    test('No collisions', () {
      final Map<String, String> classes = Map();
      final CourseUnitClass courseUnitClass1 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(1, '14h30', 'B'),
        LectureMock(1, '15h30', 'C'),
        LectureMock(3, '16h30', 'B'),
      ]);
      final CourseUnitClass courseUnitClass2 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(5, '13h30', 'A'),
        LectureMock(5, '14h30', 'B'),
        LectureMock(6, '15h30', 'A'),
        LectureMock(4, '16h30', 'A'),
      ]);
      final CourseUnitClass courseUnitClass3 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(2, '13h30', 'B'),
        LectureMock(3, '14h30', 'C'),
        LectureMock(5, '15h30', 'C'),
        LectureMock(3, '16h30', 'A'),
      ]);

      final CourseUnit courseUnit1 = CourseUnit(
          abbreviation: 'ABC',
        classes: [courseUnitClass1]
      );
      final CourseUnit courseUnit2 = CourseUnit(
          abbreviation: 'BAC',
          classes: [courseUnitClass2]
      );
      final CourseUnit courseUnit3 = CourseUnit(
          abbreviation: 'CAB',
          classes: [courseUnitClass3]
      );

      classes[courseUnit1.abbreviation] = courseUnitClass1.name;
      classes[courseUnit2.abbreviation] = courseUnitClass2.name;
      classes[courseUnit3.abbreviation] = courseUnitClass3.name;

      final ScheduleOption instance = ScheduleOption(classesSelected: classes);
      final List<CourseUnit> courseUnits = [
        courseUnit1,
        courseUnit2,
        courseUnit3
      ];

      for (int i = 0; i < 7; i++) {
        expect(instance.hasCollisions(i, courseUnits), false);
      }
    });

    test('One collision', () {
      final Map<String, String> classes = Map();
      final CourseUnitClass courseUnitClass1 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(1, '14h30', 'B'),
        LectureMock(1, '15h30', 'C'),
        LectureMock(3, '16h30', 'B'),
      ]);
      final CourseUnitClass courseUnitClass2 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(5, '13h30', 'A'),
        LectureMock(5, '14h30', 'B'),
        LectureMock(6, '15h30', 'A'),
        LectureMock(4, '16h30', 'A'),
      ]);
      final CourseUnitClass courseUnitClass3 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(2, '13h30', 'B'),
        LectureMock(3, '14h30', 'C'),
        LectureMock(5, '15h30', 'A'),
        LectureMock(3, '16h30', 'A'),
      ]);

      final CourseUnit courseUnit1 = CourseUnit(
          abbreviation: 'ABC',
        classes: [courseUnitClass1]
      );
      final CourseUnit courseUnit2 = CourseUnit(
          abbreviation: 'BAC',
          classes: [courseUnitClass2]
      );
      final CourseUnit courseUnit3 = CourseUnit(
          abbreviation: 'CAB',
          classes: [courseUnitClass3]
      );

      classes[courseUnit1.abbreviation] = courseUnitClass1.name;
      classes[courseUnit2.abbreviation] = courseUnitClass2.name;
      classes[courseUnit3.abbreviation] = courseUnitClass3.name;

      final ScheduleOption instance = ScheduleOption(classesSelected: classes);
      final List<CourseUnit> courseUnits = [
        courseUnit1,
        courseUnit2,
        courseUnit3
      ];

      for (int i = 0; i < 7; i++) {
        if (i == 5) {
          expect(instance.hasCollisions(i, courseUnits), true);
        } else {
          expect(instance.hasCollisions(i, courseUnits), false);
        }
      }
    });

    test('Many collisions', () {
      final Map<String, String> classes = Map();

      final CourseUnitClass courseUnitClass1 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(1, '14h30', 'B'),
        LectureMock(1, '15h30', 'B'),
        LectureMock(3, '16h30', 'B'),
      ]);
      final CourseUnitClass courseUnitClass2 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(5, '13h30', 'A'),
        LectureMock(5, '14h30', 'A'),
        LectureMock(6, '15h30', 'A'),
        LectureMock(4, '16h30', 'A'),
      ]);
      final CourseUnitClass courseUnitClass3 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(2, '13h30', 'B'),
        LectureMock(3, '14h30', 'C'),
        LectureMock(5, '15h30', 'A'),
        LectureMock(3, '16h30', 'C'),
      ]);

      final CourseUnit courseUnit1 = CourseUnit(
          abbreviation: 'ABC',
          classes: [courseUnitClass1]
      );
      final CourseUnit courseUnit2 = CourseUnit(
          abbreviation: 'BAC',
          classes: [courseUnitClass2]
      );
      final CourseUnit courseUnit3 = CourseUnit(
          abbreviation: 'CAB',
          classes: [courseUnitClass3]
      );

      classes[courseUnit1.abbreviation] = courseUnitClass1.name;
      classes[courseUnit2.abbreviation] = courseUnitClass2.name;
      classes[courseUnit3.abbreviation] = courseUnitClass3.name;

      final ScheduleOption instance = ScheduleOption(classesSelected: classes);
      final List<CourseUnit> courseUnits = [
        courseUnit1,
        courseUnit2,
        courseUnit3
      ];

      for (int i = 0; i < 7; i++) {
        if (i == 5 || i == 1 || i == 3) {
          expect(instance.hasCollisions(i, courseUnits), true);
        } else {
          expect(instance.hasCollisions(i, courseUnits), false);
        }
      }
    });

    test('Collisions every day', () {
      final Map<String, String> classes = Map();

      final CourseUnitClass courseUnitClass1 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(1, '14h30', 'A'),
        LectureMock(1, '15h30', 'A'),
        LectureMock(3, '16h30', 'A'),
      ]);
      final CourseUnitClass courseUnitClass2 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(5, '13h30', 'A'),
        LectureMock(2, '14h30', 'A'),
        LectureMock(6, '15h30', 'A'),
        LectureMock(4, '16h30', 'A'),
      ]);
      final CourseUnitClass courseUnitClass3 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(2, '13h30', 'A'),
        LectureMock(3, '14h30', 'A'),
        LectureMock(5, '15h30', 'A'),
        LectureMock(3, '16h30', 'A'),
      ]);
      final CourseUnitClass courseUnitClass4 = CourseUnitClass(
          name: '3LEIC01',
          lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(4, '14h30', 'A'),
        LectureMock(4, '15h30', 'A'),
        LectureMock(6, '16h30', 'A'),
      ]);

      final CourseUnit courseUnit1 = CourseUnit(
          abbreviation: 'ABC',
          classes: [courseUnitClass1]
      );
      final CourseUnit courseUnit2 = CourseUnit(
          abbreviation: 'BAC',
          classes: [courseUnitClass2]
      );
      final CourseUnit courseUnit3 = CourseUnit(
          abbreviation: 'CAB',
          classes: [courseUnitClass3]
      );
      final CourseUnit courseUnit4 = CourseUnit(
          abbreviation: 'CBA',
          classes: [courseUnitClass4]
      );

      classes[courseUnit1.abbreviation] = courseUnitClass1.name;
      classes[courseUnit2.abbreviation] = courseUnitClass2.name;
      classes[courseUnit3.abbreviation] = courseUnitClass3.name;
      classes[courseUnit4.abbreviation] = courseUnitClass4.name;

      final ScheduleOption instance = ScheduleOption(classesSelected: classes);
      final List<CourseUnit> courseUnits = [
        courseUnit1,
        courseUnit2,
        courseUnit3,
        courseUnit4
      ];

      for (int i = 0; i < 7; i++) {
        expect(instance.hasCollisions(i, courseUnits), true);
      }
    });
  });
}
