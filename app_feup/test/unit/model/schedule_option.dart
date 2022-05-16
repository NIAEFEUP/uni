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
    test('New instance has correct name and no classes selected', () {
      final ScheduleOption instance = ScheduleOption.newInstance();
      for (int i = 0; i < 7; i++) {
        expect(instance.getLectures(i).length, 0);
      }

      expect(instance.name, 'Novo Horário');
    });

    test('Get lectures', () {
      final Map<CourseUnit, CourseUnitClass> classes = Map();
      final CourseUnit courseUnit1 = CourseUnit();
      final CourseUnit courseUnit2 = CourseUnit();

      classes[courseUnit1] = CourseUnitClass(lectures: [
        LectureMock(0, '10h00', 'A'),
        LectureMock(1, '09h30', 'B'),
      ]);
      classes[courseUnit2] = CourseUnitClass(lectures: [
        LectureMock(1, '08h30', 'C'),
      ]);
      final ScheduleOption instance = ScheduleOption(classesSelected: classes);

      expect(instance.getLectures(0).length, 1);
      final List<Lecture> day1Lectures = instance.getLectures(1);
      expect(day1Lectures.length, 2);
      // Check order of lectures
      expect(day1Lectures[0].startTime, '08h30');
      expect(day1Lectures[1].startTime, '09h30');
      for (int i = 2; i < 7; i++) {
        expect(instance.getLectures(i).length, 0);
      }
    });

    test('Change class', () {
      final Map<CourseUnit, CourseUnitClass> classes = Map();
      final CourseUnit courseUnit1 = CourseUnit();

      classes[courseUnit1] = CourseUnitClass(lectures: [
        LectureMock(0, '08h30', 'A'),
        LectureMock(1, '08h30', 'B'),
      ]);
      classes[courseUnit1] = CourseUnitClass(lectures: [
        LectureMock(1, '08h30', 'B'),
      ]);
      final ScheduleOption instance = ScheduleOption(classesSelected: classes);

      for (int i = 0; i < 7; i++) {
        if (i != 1) {
          expect(instance.getLectures(i).length, 0);
        } else {
          expect(instance.getLectures(i).length, 1);
        }
      }
    });

    test('No collisions', () {
      final Map<CourseUnit, CourseUnitClass> classes = Map();
      final CourseUnit courseUnit1 = CourseUnit();
      final CourseUnit courseUnit2 = CourseUnit();
      final CourseUnit courseUnit3 = CourseUnit();

      classes[courseUnit1] = CourseUnitClass(lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(1, '14h30', 'B'),
        LectureMock(1, '15h30', 'C'),
        LectureMock(3, '16h30', 'B'),
      ]);
      classes[courseUnit2] = CourseUnitClass(lectures: [
        LectureMock(5, '13h30', 'A'),
        LectureMock(5, '14h30', 'B'),
        LectureMock(6, '15h30', 'A'),
        LectureMock(4, '16h30', 'A'),
      ]);
      classes[courseUnit3] = CourseUnitClass(lectures: [
        LectureMock(2, '13h30', 'B'),
        LectureMock(3, '14h30', 'C'),
        LectureMock(5, '15h30', 'C'),
        LectureMock(3, '16h30', 'A'),
      ]);
      final ScheduleOption instance = ScheduleOption(classesSelected: classes);

      for (int i = 0; i < 7; i++) {
        expect(instance.hasCollisions(i), false);
      }
    });

    test('One collision', () {
      final Map<CourseUnit, CourseUnitClass> classes = Map();
      final CourseUnit courseUnit1 = CourseUnit();
      final CourseUnit courseUnit2 = CourseUnit();
      final CourseUnit courseUnit3 = CourseUnit();

      classes[courseUnit1] = CourseUnitClass(lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(1, '14h30', 'B'),
        LectureMock(1, '15h30', 'C'),
        LectureMock(3, '16h30', 'B'),
      ]);
      classes[courseUnit2] = CourseUnitClass(lectures: [
        LectureMock(5, '13h30', 'A'),
        LectureMock(5, '14h30', 'B'),
        LectureMock(6, '15h30', 'A'),
        LectureMock(4, '16h30', 'A'),
      ]);
      classes[courseUnit3] = CourseUnitClass(lectures: [
        LectureMock(2, '13h30', 'B'),
        LectureMock(3, '14h30', 'C'),
        LectureMock(5, '15h30', 'A'),
        LectureMock(3, '16h30', 'A'),
      ]);
      final ScheduleOption instance = ScheduleOption(classesSelected: classes);

      for (int i = 0; i < 7; i++) {
        if (i == 5) {
          expect(instance.hasCollisions(i), true);
        } else {
          expect(instance.hasCollisions(i), false);
        }
      }
    });

    test('Many collisions', () {
      final Map<CourseUnit, CourseUnitClass> classes = Map();
      final CourseUnit courseUnit1 = CourseUnit();
      final CourseUnit courseUnit2 = CourseUnit();
      final CourseUnit courseUnit3 = CourseUnit();

      classes[courseUnit1] = CourseUnitClass(lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(1, '14h30', 'B'),
        LectureMock(1, '15h30', 'B'),
        LectureMock(3, '16h30', 'B'),
      ]);
      classes[courseUnit2] = CourseUnitClass(lectures: [
        LectureMock(5, '13h30', 'A'),
        LectureMock(5, '14h30', 'A'),
        LectureMock(6, '15h30', 'A'),
        LectureMock(4, '16h30', 'A'),
      ]);
      classes[courseUnit3] = CourseUnitClass(lectures: [
        LectureMock(2, '13h30', 'B'),
        LectureMock(3, '14h30', 'C'),
        LectureMock(5, '15h30', 'A'),
        LectureMock(3, '16h30', 'C'),
      ]);
      final ScheduleOption instance = ScheduleOption(classesSelected: classes);

      for (int i = 0; i < 7; i++) {
        if (i == 5 || i == 1 || i == 3) {
          expect(instance.hasCollisions(i), true);
        } else {
          expect(instance.hasCollisions(i), false);
        }
      }
    });

    test('Collisions every day', () {
      final Map<CourseUnit, CourseUnitClass> classes = Map();
      final CourseUnit courseUnit1 = CourseUnit();
      final CourseUnit courseUnit2 = CourseUnit();
      final CourseUnit courseUnit3 = CourseUnit();
      final CourseUnit courseUnit4 = CourseUnit();

      classes[courseUnit1] = CourseUnitClass(lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(1, '14h30', 'A'),
        LectureMock(1, '15h30', 'A'),
        LectureMock(3, '16h30', 'A'),
      ]);
      classes[courseUnit2] = CourseUnitClass(lectures: [
        LectureMock(5, '13h30', 'A'),
        LectureMock(2, '14h30', 'A'),
        LectureMock(6, '15h30', 'A'),
        LectureMock(4, '16h30', 'A'),
      ]);
      classes[courseUnit3] = CourseUnitClass(lectures: [
        LectureMock(2, '13h30', 'A'),
        LectureMock(3, '14h30', 'A'),
        LectureMock(5, '15h30', 'A'),
        LectureMock(3, '16h30', 'A'),
      ]);
      classes[courseUnit4] = CourseUnitClass(lectures: [
        LectureMock(0, '13h30', 'A'),
        LectureMock(4, '14h30', 'A'),
        LectureMock(4, '15h30', 'A'),
        LectureMock(6, '16h30', 'A'),
      ]);
      final ScheduleOption instance = ScheduleOption(classesSelected: classes);

      for (int i = 0; i < 7; i++) {
        expect(instance.hasCollisions(i), true);
      }
    });
  });
}
