import 'package:redux_thunk/redux_thunk.dart';
import '../model/AppState.dart';
import 'actions.dart';
import 'package:redux/redux.dart';

ThunkAction<AppState> login(name, password) {
  return (Store<AppState> store) async {
    //do requests, await futures

    String cookies = name + password;

    store.dispatch(new SaveLoginDataAction(cookies));
  };
}
