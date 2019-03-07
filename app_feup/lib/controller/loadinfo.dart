import 'dart:async';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';

loadUserInfoToState(store){
  Completer<Null> exams = new Completer(), schedule = new Completer();
  store.dispatch(getUserExams(exams));
  store.dispatch(getUserSchedule(schedule));
  return Future.wait([exams.future, schedule.future]);
}

Future<void> handleRefresh(store){
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}