import 'dart:async';
import 'package:redux/redux.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/controller/loadinfo.dart';

class RefreshItemsAction {
  final Completer<Null> completer;

  RefreshItemsAction({Completer completer})
      : this.completer = completer ?? Completer<Null>();
}

void refreshItemsMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
){
  if(action is RefreshItemsAction){
    loadUserInfoToState(store);
    action.completer.complete();
  }
}