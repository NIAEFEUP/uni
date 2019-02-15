import 'package:redux_thunk/redux_thunk.dart';
import '../model/AppState.dart';
import 'actions.dart';
import 'package:redux/redux.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';

ThunkAction<AppState> login(username, password, persistentSession) {
  return (Store<AppState> store) async {
    //do requests, await futures
    try {
      final Map<String, dynamic> session = await NetworkRouter.login(username, password, persistentSession);
      print(session);
      store.dispatch(new SaveLoginDataAction(session));
      store.dispatch(fetchProfile());
    } catch (e) {
      store.dispatch(new SetLoginMessageAction('Login failed: ${e.toString()}'));
    }
  };
}

ThunkAction<AppState> fetchProfile() {
  return (Store<AppState> store) async {
    try {
      final String name = await NetworkRouter.getProfile(store.state.content['session']);
      store.dispatch(new SetLoginMessageAction(name));
    } catch (e) {
      print(e);
    }
  };
}
