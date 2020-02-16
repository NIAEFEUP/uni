import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:uni/model/AppState.dart';
import 'package:uni/controller/LoadInfo.dart';
import 'package:uni/redux/RefreshItemsAction.dart';

void generalMiddleware(
    Store<AppState> store,
    dynamic action,
    NextDispatcher next,
    ){
  if (action is RefreshItemsAction) {
//    Future.wait(loadUserInfoToState(store)).then((List responses) => action.completer.complete());
    loadUserInfoToState(store).whenComplete( () => action.completer.complete());
  }else if (action is ThunkAction<AppState>) {
    action(store);
  } else {
    next(action);
  }
}