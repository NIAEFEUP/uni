import 'dart:async';
import 'package:app_feup/redux/actionCreators.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';

loadUserInfoToState(store){
  print("Loading info to State\n");
  store.dispatch(getUserExams());
  store.dispatch(getUserSchedule());
}

Future<void> handleRefresh(store){
  final action = new RefreshItemsAction();
  store.dispatch(action);
  return action.completer.future;
//    return new Future.delayed(new Duration(seconds: 1), (){
//      print("Meias\n");
//      final action = new RefreshItemsAction();
//      store.dispatch(action);
//    });
}