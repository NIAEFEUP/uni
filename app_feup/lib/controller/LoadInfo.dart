import 'dart:async';
import 'dart:io';
import 'package:app_feup/controller/local_storage/AppSharedPreferences.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';
import 'package:app_feup/redux/Actions.dart';
import 'package:tuple/tuple.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:redux/redux.dart';
import 'local_storage/ImageOfflineStorage.dart';

Future loadUserInfoToState(store) {
  loadLocalUserInfoToState(store);
  return loadRemoteUserInfoToState(store);
}

Future loadRemoteUserInfoToState(Store<AppState> store) {
  if (store.state.content['session'] == null) {
    return null;
  }

  Completer<Null> userInfo = new Completer(),
      exams = new Completer(),
      schedule = new Completer(),
      printBalance = new Completer(),
      fees = new Completer(),
      coursesStates = new Completer(),
      lastUpdate = new Completer();
  store.dispatch(getUserInfo(userInfo));
  store.dispatch(getUserSchedule(schedule));
  store.dispatch(getUserPrintBalance(printBalance));
  store.dispatch(getUserFees(fees));
  store.dispatch(getUserCoursesState(coursesStates));
  userInfo.future.then((value) => store.dispatch(getUserExams(exams)));
  final allRequests = Future.wait([
    exams.future,
    schedule.future,
    printBalance.future,
    fees.future,
    coursesStates.future,
    userInfo.future,
  ]);
  allRequests.then((futures) {
    store.dispatch(setLastUpdateTimestamp(lastUpdate));
  });
  return lastUpdate.future; 
}

void loadLocalUserInfoToState(store) async {
  store.dispatch(
      UpdateFavoriteCards(await AppSharedPreferences.getFavoriteCards()));
  Tuple2<String, String> userPersistentInfo =
      await AppSharedPreferences.getPersistentUserInfo();
  if (userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
    store.dispatch(updateStateBasedOnLocalProfile());
    store.dispatch(updateStateBasedOnLocalUserExams());
    store.dispatch(updateStateBasedOnLocalUserLectures());
    store.dispatch(updateStateBasedOnLocalRefreshTimes());
    store.dispatch(updateStateBasedOnLocalTime());
    store.dispatch(SaveProfileStatusAction(RequestStatus.SUCCESSFUL));
    store.dispatch(SetPrintBalanceStatusAction(RequestStatus.SUCCESSFUL));
    store.dispatch(SetFeesStatusAction(RequestStatus.SUCCESSFUL));
    store.dispatch(SetCoursesStatesStatusAction(RequestStatus.SUCCESSFUL));
  }
}

Future<void> handleRefresh(store) {
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}

Future<File> loadProfilePic(Store<AppState> store) {
  final String studentNo = store.state.content['session'].studentNumber;
  String url = "https://sigarra.up.pt/feup/pt/fotografias_service.foto?pct_cod=";
  final Map<String, String> headers = Map<String, String>();

  if(studentNo != null) {
    url += studentNo;
    headers['cookie'] = store.state.content['session'].cookies;
  }
  return retrieveImage(url, headers);
}
