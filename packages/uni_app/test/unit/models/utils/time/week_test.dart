import 'package:flutter_test/flutter_test.dart';
import 'package:uni/model/utils/time/week.dart';

void main() {
  group('Week', () {
    final week1 = Week(start: DateTime(2024, 2, 29));
    final week2 = Week(start: DateTime(2024, 3, 3));

    group('startingOn', () {
      test('should return the same week if the starting day is the same', () {
        expect(week1.startingOn(DateTime.thursday), week1);
        expect(week2.startingOn(DateTime.sunday), week2);
      });

      group(
          'should return a week that starts in the given weekday, after the'
          " current week's start and before the next one's", () {
        test('week1, starting on Sunday', () {
          expect(
            week1.startingOn(DateTime.sunday).start.weekday,
            DateTime.sunday,
          );

          expect(
            week1.startingOn(DateTime.sunday).start.isAfter(week1.start),
            true,
          );

          expect(
            week1
                .startingOn(DateTime.sunday)
                .start
                .isBefore(week1.next().start),
            true,
          );
        });

        test('week1, ending on Monday', () {
          expect(
            week1.startingOn(DateTime.monday).start.weekday,
            DateTime.monday,
          );

          expect(
            week1.startingOn(DateTime.monday).start.isAfter(week1.start),
            true,
          );

          expect(
            week1
                .startingOn(DateTime.monday)
                .start
                .isBefore(week1.next().start),
            true,
          );
        });

        test('week2, ending on Monday', () {
          expect(
            week2.startingOn(DateTime.monday).start.weekday,
            DateTime.monday,
          );

          expect(
            week2.startingOn(DateTime.monday).start.isAfter(week2.start),
            true,
          );

          expect(
            week2
                .startingOn(DateTime.monday)
                .start
                .isBefore(week2.next().start),
            true,
          );
        });

        test('week2, ending on Saturday', () {
          expect(
            week2.startingOn(DateTime.saturday).start.weekday,
            DateTime.saturday,
          );

          expect(
            week2.startingOn(DateTime.saturday).start.isAfter(week2.start),
            true,
          );

          expect(
            week2
                .startingOn(DateTime.saturday)
                .start
                .isBefore(week2.next().start),
            true,
          );
        });
      });
    });

    group('endingOn', () {
      test('should return the same week if the ending day is the same', () {
        expect(week1.endingOn(DateTime.thursday), week1);
        expect(week2.endingOn(DateTime.sunday), week2);
      });

      group(
          'should return a week that ends in the given weekday, before the'
          " current week's end and after the previous one's", () {
        test('week1, ending on Sunday', () {
          expect(
            week1.endingOn(DateTime.sunday).end.weekday,
            DateTime.sunday,
          );

          expect(
            week1.endingOn(DateTime.sunday).end.isBefore(week1.end),
            true,
          );

          expect(
            week1.endingOn(DateTime.sunday).end.isAfter(week1.previous().end),
            true,
          );
        });

        test('week1, ending on Monday', () {
          expect(
            week1.endingOn(DateTime.monday).end.weekday,
            DateTime.monday,
          );

          expect(
            week1.endingOn(DateTime.monday).end.isBefore(week1.end),
            true,
          );

          expect(
            week1.endingOn(DateTime.monday).end.isAfter(week1.previous().end),
            true,
          );
        });

        test('week2, ending on Monday', () {
          expect(
            week2.endingOn(DateTime.monday).end.weekday,
            DateTime.monday,
          );

          expect(
            week2.endingOn(DateTime.monday).end.isBefore(week2.end),
            true,
          );

          expect(
            week2.endingOn(DateTime.monday).end.isAfter(week1.previous().end),
            true,
          );
        });

        test('week2, ending on Saturday', () {
          expect(
            week2.endingOn(DateTime.saturday).end.weekday,
            DateTime.saturday,
          );

          expect(
            week2.endingOn(DateTime.saturday).end.isBefore(week2.end),
            true,
          );

          expect(
            week2.endingOn(DateTime.saturday).end.isAfter(week1.previous().end),
            true,
          );
        });
      });
    });

    group('getWeekday', () {
      group(
          'should return a day within the same week, with the'
          ' requested weekday', () {
        for (var i = 0; i < 7; i++) {
          test('[DateTime.weekday = ${i + 1}]', () {
            final weekday = DateTime.monday + i;
            final day = week1.getWeekday(weekday);
            expect(day.weekday, weekday);
            expect(week1.contains(day), true);
          });
        }
      });
    });
  });
}
