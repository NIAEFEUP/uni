import 'package:uni/model/class_registration_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Semester', () {
    test('Semester to int', () {
      expect(Semester.first.toInt(), 1);
      expect(Semester.second.toInt(), 2);
    });

    test('Semester to code', () {
      expect(Semester.first.toCode(), '1S');
      expect(Semester.second.toCode(), '2S');
    });

    test('Semester to name', () {
      expect(Semester.first.toName(), '1º Semestre');
      expect(Semester.second.toName(), '2º Semestre');
    });

    test('Semester from int', () {
      expect(SemesterUtils.fromInt(1), Semester.first);
      expect(SemesterUtils.fromInt(2), Semester.second);
    });

    test('Semester from code', () {
      expect(SemesterUtils.fromCode('1S'), Semester.first);
      expect(SemesterUtils.fromCode('2S'), Semester.second);
    });
  });
}
