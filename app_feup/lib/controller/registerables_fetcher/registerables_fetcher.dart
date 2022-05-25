import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:redux/redux.dart';

abstract class RegisterablesFetcher {
  Future<List<CourseUnit>> getRegisterables(Store<AppState> store);
}