import '../model/AppState.dart';
import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SaveLoginDataAction) {
    return login(state, action);
  }
  if (action is SetLoginMessageAction) {
    return setLoginMessage(state, action);
  }
  return state;
}

AppState login(AppState state, SaveLoginDataAction action) {
  print('setting state: ' + action.session.toString());
  return state.cloneAndUpdateValue('session', action.session);
}

AppState setLoginMessage(AppState state, SetLoginMessageAction action) {
  print('setting login message: ' + action.loginMessage);
  return state.cloneAndUpdateValue('loginMessage', action.loginMessage);
}
