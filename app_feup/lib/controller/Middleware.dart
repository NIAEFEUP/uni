import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/controller/loadinfo.dart';
import 'package:app_feup/redux/RefreshItemsAction.dart';

void generalMiddleware(
    Store<AppState> store,
    dynamic action,
    NextDispatcher next,
    ){
  if(action is RefreshItemsAction){
    loadUserInfoToState(store);
    action.completer.complete();
  }else if (action is ThunkAction<AppState>) {
    action(store);
  } else {
    next(action);
  }
}