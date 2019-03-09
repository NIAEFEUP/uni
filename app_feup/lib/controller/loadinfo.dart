import 'dart:async';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';

loadUserInfoToState(store){
  Completer<Null>
      exams = new Completer(),
      schedule = new Completer(),
      printBalance = new Completer(),
      feesBalance = new Completer();
  store.dispatch(getUserExams(exams));
  store.dispatch(getUserSchedule(schedule));
  store.dispatch(getUserPrintBalance(printBalance));
  store.dispatch(getUserFeesBalance(feesBalance));
  return Future.wait([exams.future, schedule.future, printBalance.future, feesBalance.future]);
}

Future<void> handleRefresh(store){
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}