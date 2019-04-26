import 'dart:async';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';
import 'package:redux/redux.dart';

Future loadUserInfoToState(Store<AppState> store){
  if(store.state.content['session'] == null){
    return null;
  }
  Completer<Null>
      userInfo = new Completer(),
      exams = new Completer(),
      schedule = new Completer(),
      printBalance = new Completer(),
      feesBalance = new Completer();
  store.dispatch(getUserInfo(userInfo));
  store.dispatch(getUserExams(exams));
  store.dispatch(getUserSchedule(schedule));
  store.dispatch(getUserPrintBalance(printBalance));
  store.dispatch(getUserFeesBalance(feesBalance));
  return Future.wait([exams.future, schedule.future, printBalance.future, feesBalance.future, userInfo.future]);
}

Future<void> handleRefresh(store){
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}