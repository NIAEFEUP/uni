import 'package:uni/model/entities/lecture.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Lecture', () {
    test('Lectures should collide', () {
      final lecture1 =
          Lecture(null, null, 0, null, null, null, null, 8, 30, 10, 30);

      final lecture2 =
          Lecture(null, null, 0, null, null, null, null, 10, 0, 10, 30);

      final lecture3 =
          Lecture(null, null, 0, null, null, null, null, 10, 30, 12, 30);

      final lecture4 =
          Lecture(null, null, 0, null, null, null, null, 8, 30, 11, 30);

      expect(lecture1.collidesWith(lecture2), true);
      expect(lecture3.collidesWith(lecture4), true);
      expect(lecture1.collidesWith(lecture2), true);
    });

    test('Lectures should not collide', () {
      final lecture1 =
          Lecture(null, null, 0, null, null, null, null, 8, 30, 9, 30);

      final lecture2 =
          Lecture(null, null, 0, null, null, null, null, 10, 0, 10, 30);

      final lecture3 =
          Lecture(null, null, 0, null, null, null, null, 8, 30, 10, 0);

      final lecture4 =
          Lecture(null, null, 0, null, null, null, null, 10, 30, 11, 0);

      final lecture5 =
          Lecture(null, null, 1, null, null, null, null, 8, 30, 9, 30);

      expect(lecture1.collidesWith(lecture2), false);
      expect(lecture2.collidesWith(lecture3), false);
      expect(lecture3.collidesWith(lecture4), false);
      expect(lecture1.collidesWith(lecture5), false);
    });

    test('Lecture list should have 3 discontinuities', () {
      final lecture1 =
          Lecture(null, null, 0, null, null, null, null, 8, 30, 9, 30);

      final lecture2 =
          Lecture(null, null, 0, null, null, null, null, 10, 0, 10, 30);

      final lecture3 =
          Lecture(null, null, 0, null, null, null, null, 10, 30, 12, 30);

      final lecture4 =
          Lecture(null, null, 0, null, null, null, null, 14, 0, 15, 0);

      final lecture5 =
          Lecture(null, null, 0, null, null, null, null, 15, 30, 18, 0);

      final lecture6 =
          Lecture(null, null, 0, null, null, null, null, 18, 0, 19, 0);

      final lectures = [
        lecture1,
        lecture2,
        lecture3,
        lecture4,
        lecture5,
        lecture6
      ];

      final discontinuities = Lecture.getDiscontinuities(lectures);

      expect(discontinuities[1], true);
      expect(discontinuities[2], false);
      expect(discontinuities[3], true);
      expect(discontinuities[4], true);
      expect(discontinuities[5], false);
    });

    test('Lecture list should have 3 collisions', () {
      final lecture1 =
          Lecture(null, null, 0, null, null, null, null, 8, 30, 9, 30);

      final lecture2 =
          Lecture(null, null, 0, null, null, null, null, 9, 0, 10, 30);

      final lecture3 =
          Lecture(null, null, 0, null, null, null, null, 10, 30, 12, 30);

      final lecture4 =
          Lecture(null, null, 0, null, null, null, null, 8, 45, 9, 0);

      final lecture5 =
          Lecture(null, null, 0, null, null, null, null, 15, 30, 18, 0);

      final lecture6 =
          Lecture(null, null, 0, null, null, null, null, 18, 0, 19, 0);

      final lectures = [
        lecture1,
        lecture2,
        lecture3,
        lecture4,
        lecture5,
        lecture6
      ];

      final hasCollision = Lecture.getCollisions(lectures);

      expect(hasCollision[0], true);
      expect(hasCollision[1], true);
      expect(hasCollision[2], false);
      expect(hasCollision[3], true);
      expect(hasCollision[4], false);
      expect(hasCollision[5], false);
    });
  });
}
