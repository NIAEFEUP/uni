import 'package:redux_thunk/redux_thunk.dart';
import '../model/AppState.dart';
import 'actions.dart';
import 'package:redux/redux.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';

ThunkAction<AppState> login(username, password) {
  return (Store<AppState> store) async {
    //do requests, await futures
    final Map<String, dynamic> session = await NetworkRouter.login(username, password);
    print(session);
    store.dispatch(new SaveLoginDataAction(session));
  };
}
