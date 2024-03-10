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

void ensureMapperEquivalenceByStartWeekdays(
  int fromStart,
  int fromStartWeekday,
  int toStart,
  int toStartWeekday,
) {
  group(
      'When mapping from $fromStart..${fromStart + 6}'
      ' (start.weekday = $fromStartWeekday to $toStart..${toStart + 6}'
      ' (start.weekday = $toStartWeekday)', () {
    test('should be correctly created', () {
      final equivalent = WeekdayMapper(
        fromStart: fromStart,
        fromMonday: WeekdayMapper.fromStartWeekdays(
          fromStart: 1,
          fromStartWeekday: DateTime.monday,
          toStart: fromStart,
          toStartWeekday: fromStartWeekday,
        ).map(DateTime.monday),
        toStart: toStart,
        toMonday: WeekdayMapper.fromStartWeekdays(
          fromStart: 1,
          fromStartWeekday: DateTime.monday,
          toStart: toStart,
          toStartWeekday: toStartWeekday,
        ).map(DateTime.monday),
      );

      final mapper = WeekdayMapper.fromStartWeekdays(
        fromStart: fromStart,
        fromStartWeekday: fromStartWeekday,
        toStart: toStart,
        toStartWeekday: toStartWeekday,
      );

      expect(mapper, equivalent);
    });
  });
}

void main() {
  group('WeekdayMapper', () {
    group('map', () {
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
  });

  group('constructor fromStartWeekdays', () {
    // There are three main states for `fromStart` and `toStart`:
    // - fromStart < toStart
    // - fromStart = toStart
    // - fromStart > toStart

    // The same goes for `fromStartWeekday` and `toStartWeekday`.

    ensureMapperEquivalenceByStartWeekdays(
      2,
      DateTime.tuesday,
      3,
      DateTime.thursday,
    );
    ensureMapperEquivalenceByStartWeekdays(
      2,
      DateTime.wednesday,
      3,
      DateTime.wednesday,
    );
    ensureMapperEquivalenceByStartWeekdays(
      2,
      DateTime.thursday,
      3,
      DateTime.tuesday,
    );

    ensureMapperEquivalenceByStartWeekdays(
      2,
      DateTime.tuesday,
      2,
      DateTime.thursday,
    );
    ensureMapperEquivalenceByStartWeekdays(
      2,
      DateTime.wednesday,
      2,
      DateTime.wednesday,
    );
    ensureMapperEquivalenceByStartWeekdays(
      2,
      DateTime.thursday,
      2,
      DateTime.tuesday,
    );

    ensureMapperEquivalenceByStartWeekdays(
      3,
      DateTime.tuesday,
      2,
      DateTime.thursday,
    );
    ensureMapperEquivalenceByStartWeekdays(
      3,
      DateTime.wednesday,
      2,
      DateTime.wednesday,
    );
    ensureMapperEquivalenceByStartWeekdays(
      3,
      DateTime.thursday,
      2,
      DateTime.tuesday,
    );
  });
}
