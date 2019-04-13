import 'dart:async';
import 'package:app_feup/controller/local_storage/AppSharedPreferences.dart';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';
import 'package:tuple/tuple.dart';

Future loadRemoteUserInfoToState(store) {
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

Future loadUserInfoToState(store) {

  loadLocalUserInfoToState(store);
  return loadRemoteUserInfoToState(store);

}

void loadLocalUserInfoToState(store) async {
  Tuple2<String, String> userPersistentInfo = await AppSharedPreferences.getPersistentUserInfo();
  if(userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
    store.dispatch(updateStateBasedOnLocalUserExams());
    store.dispatch(updateStateBasedOnLocalUserLectures());
  }
}

Future<void> handleRefresh(store){
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}