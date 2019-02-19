import '../model/AppState.dart';
import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SaveLoginDataAction) {
    return login(state, action);
  }
  else if (action is SetExamsAction){
    return setExams(state, action);
  }
  return state;
}

AppState login(AppState state, SaveLoginDataAction action) {
  print('setting state: ' + action.cookies);
  return state.cloneAndUpdateValue("cookies", action.cookies);
}

AppState setExams(AppState state, SetExamsAction action) {
  return state.cloneAndUpdateValue("exams", action.exams);
}