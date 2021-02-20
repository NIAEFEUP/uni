import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';

abstract class ScheduleFetcher {
  Future<List<Lecture>> getLectures(Store<AppState> store);

  Dates getDates() {
    var date = DateTime.now();

    final String beginWeek = date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');
    date = date.add(Duration(days: 6));

    final String endWeek = date.year.toString().padLeft(4, '0') +
        date.month.toString().padLeft(2, '0') +
        date.day.toString().padLeft(2, '0');

    return Dates(beginWeek, endWeek);
  }
}

class Dates {
  final String beginWeek;
  final String endWeek;

  Dates(this.beginWeek, this.endWeek); 
}
