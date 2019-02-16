import '../model/AppState.dart';
import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SaveLoginDataAction) {
    return login(state, action);
  }
  else if(action is UpdateSelectedPageAction) {
    return updateSelectedPage(state, action);
  }
  return state;
}

AppState updateSelectedPage(AppState state, UpdateSelectedPageAction action) {
  print('updating selected page: ' + action.selected_page);
  return state.cloneAndUpdateValue("selected_page", action.selected_page);
}

AppState login(AppState state, SaveLoginDataAction action) {
  print('setting state: ' + action.cookies);
  return state.cloneAndUpdateValue("cookies", action.cookies);
}