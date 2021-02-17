import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';


abstract class ScheduleFetcher{
  Future<List<Lecture>> getLectures(Store<AppState> store);
}