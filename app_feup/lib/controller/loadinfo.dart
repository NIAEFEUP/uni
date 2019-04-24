import 'dart:async';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';

Future loadUserInfoToState(store){
  Completer<Null>
      userInfo = new Completer(),
      exams = new Completer(),
      schedule = new Completer(),
      printBalance = new Completer(),
      feesBalance = new Completer(),
      feesLimit = new Completer(),
      coursesStates = new Completer();
  store.dispatch(getUserInfo(userInfo));
  store.dispatch(getUserExams(exams));
  store.dispatch(getUserSchedule(schedule));
  store.dispatch(getUserPrintBalance(printBalance));
  store.dispatch(getUserFeesBalance(feesBalance));
  store.dispatch(getUserFeesNextLimit(feesLimit));
  store.dispatch(getUserCoursesState(coursesStates));
  return Future.wait([exams.future, schedule.future, printBalance.future, feesBalance.future, feesLimit.future, coursesStates.future, userInfo.future]);
}

Future<void> handleRefresh(store){
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}