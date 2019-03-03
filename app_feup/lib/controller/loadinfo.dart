import 'dart:async';

import 'package:app_feup/redux/actionCreators.dart';

loadUserInfoToState(store){
  store.dispatch(getUserExams());
  store.dispatch(getUserSchedule());
}

Future<void> handleRefresh(store){
  Completer action = new Completer();
  store.dispatch(action);
  return action.future;
}