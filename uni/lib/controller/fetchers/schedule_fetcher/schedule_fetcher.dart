import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/utils/time/week.dart';

/// Class for fetching the user's schedule.
abstract class ScheduleFetcher extends SessionDependantFetcher {
  // Returns the user's lectures.
  Future<List<Lecture>> getLectures(Session session, Profile profile);

  List<Week> getWeeks(DateTime now) {
    final week = Week(start: now);

    // In a 7-day period, there are at most 2 weeks. According to SIGARRA
    // convention, weeks start on Sundays.
    // Also, for `nextWeek`, we can't use `thisWeek.next()` because it could
    // return a week that doesn't intersect `week` (if `week` starts on a
    // Sunday).
    final thisWeek = week.endingOn(DateTime.sunday);
    final nextWeek = week.startingOn(DateTime.sunday);

    return thisWeek == nextWeek ? [thisWeek] : [thisWeek, nextWeek];
  }

  /// Returns [Dates].
  List<Dates> getDates() {
    final date = DateTime.now();

    final weeks = getWeeks(date);
    final lectiveYear = date.month < 8 ? date.year - 1 : date.year;

    return weeks.map((week) => Dates(week, lectiveYear)).toList();
  }
}

/// Stores the start and end dates of the week and the current lective year.
class Dates {
  Dates(this.week, this.lectiveYear);
  final Week week;
  final int lectiveYear;

  String _toSigarraDate(DateTime date) {
    return date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');
  }

  String get asSigarraWeekStart => _toSigarraDate(week.start);
  String get asSigarraWeekEnd =>
      _toSigarraDate(week.end.subtract(const Duration(days: 1)));
}
