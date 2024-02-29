import 'package:flutter_test/flutter_test.dart';
import 'package:uni/model/utils/time/weekday_mapper.dart';

void exhaustivelyTestWeekdayMapper(
  int fromStart,
  int fromMonday,
  int toStart,
  int toMonday,
) {
  group(
      'When mapping from $fromStart..${fromStart + 6} (monday = $fromMonday)'
      ' to $toStart..${toStart + 6} (monday = $toMonday)', () {
    final mapper = WeekdayMapper(
      fromStart: fromStart,
      fromMonday: fromMonday,
      toStart: toStart,
      toMonday: toMonday,
    );

    final inverseMapper = mapper.inverse;

    final fromEnd = fromStart + 7;
    final toEnd = toStart + 7;

    var fromWeekday = fromMonday;
    var toWeekday = toMonday;

    for (var i = 0; i < 7; i++) {
      test(
          '[DateTime.weekday = ${i + 1}] fromWeekday = $fromWeekday should'
          ' map to toWeekday = $toMonday', () {
        expect(mapper.map(fromWeekday), toWeekday);
      });

      test(
          '[DateTime.weekday = ${i + 1}] toWeekday = $toWeekday should'
          ' inversely map to fromWeekday = $fromWeekday', () {
        expect(inverseMapper.map(toWeekday), fromWeekday);
      });

      fromWeekday = ++fromWeekday >= fromEnd ? fromStart : fromWeekday;
      toWeekday = ++toWeekday >= toEnd ? toStart : toWeekday;
    }
  });
}

void main() {
  group('WeekdayMapper', () {
    // There are three main states for `fromStart` and `toStart`:
    // - fromStart < toStart
    // - fromStart = toStart
    // - fromStart > toStart

    // The same goes for `fromMonday` and `toMonday`.

    exhaustivelyTestWeekdayMapper(2, 4, 3, 5);
    exhaustivelyTestWeekdayMapper(2, 4, 3, 4);
    exhaustivelyTestWeekdayMapper(2, 5, 3, 4);

    exhaustivelyTestWeekdayMapper(2, 4, 2, 5);
    exhaustivelyTestWeekdayMapper(2, 4, 2, 4);
    exhaustivelyTestWeekdayMapper(2, 5, 2, 4);

    exhaustivelyTestWeekdayMapper(3, 4, 2, 5);
    exhaustivelyTestWeekdayMapper(3, 4, 2, 4);
    exhaustivelyTestWeekdayMapper(3, 5, 2, 4);
  });
}
