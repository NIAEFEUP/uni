import 'dart:async';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';

loadUserInfoToState(store){
  store.dispatch(getUserExams());
  store.dispatch(getUserSchedule());
}

Future<void> handleRefresh(store){
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
}