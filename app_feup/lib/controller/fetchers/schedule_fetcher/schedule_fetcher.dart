import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';

/// Class for fetching the user's schedule.
abstract class ScheduleFetcher {
  // Returns the user's lectures.
  Future<List<Lecture>> getLectures(Store<AppState> store);

  /// Returns [Dates].
  Dates getDates() {
    var date = DateTime.now();

    final String beginWeek = date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');
    date = date.add(Duration(days: 6));

    final String endWeek = date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');

    final lectiveYear = date.month < 8 ? date.year - 1 : date.year;
    return Dates(beginWeek, endWeek, lectiveYear);
  }
}

/// Stores the start and end dates of the week and the current lective year.
class Dates {
  final String beginWeek;
  final String endWeek;
  final int lectiveYear;

  Dates(this.beginWeek, this.endWeek, this.lectiveYear);
}
