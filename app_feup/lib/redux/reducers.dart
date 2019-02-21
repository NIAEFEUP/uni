import '../model/AppState.dart';
import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SaveLoginDataAction) {
    return login(state, action);
  } else if (action is SetLoginStatusAction) {
    return setLoginStatus(state, action);
  } else if (action is SetExamsAction){
    return setExams(state, action);
  } else if(action is UpdateSelectedPageAction) {
    return updateSelectedPage(state, action);
  }
  return state;
}

AppState updateSelectedPage(AppState state, UpdateSelectedPageAction action) {
  print('updating selected page: ' + action.selected_page);
  return state.cloneAndUpdateValue("selected_page", action.selected_page);
}

AppState login(AppState state, SaveLoginDataAction action) {
  print('setting state: ' + action.session.toString());
  return state.cloneAndUpdateValue('session', action.session);
}

AppState setLoginStatus(AppState state, SetLoginStatusAction action) {
  print('setting login status: ' + action.status.toString());
  return state.cloneAndUpdateValue('loginStatus', action.status);
}

AppState setExams(AppState state, SetExamsAction action) {
  return state.cloneAndUpdateValue("exams", action.exams);
}