import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

/// Class for fetching the user's schedule.
abstract class ScheduleFetcher extends SessionDependantFetcher {
  // Returns the user's lectures.
  Future<List<Lecture>> getLectures(Session session, Profile profile);

  Tuple2<DateTime, DateTime> getWeekStartEndDates() {
    var start = DateTime.now().copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );

    final mappedWeekday = start.weekday % 7;
    final weekStart = start.add(Duration(days: -mappedWeekday));

    final end = start.add(const Duration(days: 6));

    return Tuple2(weekStart, end);
  }

  List<Tuple2<DateTime, DateTime>> getBlocks(Tuple2<DateTime, DateTime> week) {
    // A block starts on sunday and ends on a saturday. At most, there is 1
    // block per week.
    final blocks = <Tuple2<DateTime, DateTime>>[];

    var start = week.item1;
    final end = week.item2;

    while (true) {
      // Sunday has weekday = 7, and `Datetime.saturday - start.weekday` would
      // be equal to -1. To solve this, we use the modulo operator to map
      // sunday to 0.
      final mappedWeekday = start.weekday % 7;
      final daysUntilSaturday = DateTime.saturday - mappedWeekday;
      Logger().d('Start: $start; Days until saturday: $daysUntilSaturday');
      final nextSaturday = start.add(Duration(days: daysUntilSaturday));

      if (nextSaturday.isAfter(end)) {
        blocks.add(Tuple2(start, end));
        print(blocks);
        return blocks;
      }

      blocks.add(Tuple2(start, nextSaturday));
      start = nextSaturday.add(const Duration(days: 1));
    }
  }

  String toSigarraDate(DateTime date) {
    return date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');
  }

  /// Returns [Dates].
  Dates getDates() {
    var date = DateTime.now();

    final beginWeek = date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');
    date = date.add(const Duration(days: 6));

    final endWeek = date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');

    final lectiveYear = date.month < 8 ? date.year - 1 : date.year;
    return Dates(beginWeek, endWeek, lectiveYear);
  }
}

/// Stores the start and end dates of the week and the current lective year.
class Dates {
  Dates(this.beginWeek, this.endWeek, this.lectiveYear);
  final String beginWeek;
  final String endWeek;
  final int lectiveYear;
}
