import '../model/AppState.dart';
import 'actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SaveLoginDataAction) {
    return login(state, action);
  } else if (action is SetLoginStatusAction) {
    return setLoginStatus(state, action);
  } else if (action is UpdateSelectedPageAction) {
    return updateSelectedPage(state, action);
  } else if (action is SetExamsAction) {
    return setExams(state, action);
  } else if (action is SetScheduleAction) {
    return setSchedule(state, action);
  } else if (action is SaveProfileAction) {
    return saveProfile(state, action);
  } else if (action is SaveUcsAction) {
    return saveCurrUcs(state, action);
  } else if(action is SetPrintBalanceAction) {
    return setPrintBalance(state, action);
  } else if(action is SetFeesBalanceAction) {
    return setFeesBalance(state, action);
  } else if(action is SetFeesLimitAction) {
    return setFeesLimit(state, action);
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
  print('setting exams: ' + action.exams.length.toString());
  return state.cloneAndUpdateValue("exams", action.exams);
}

AppState setSchedule(AppState state, SetScheduleAction action) {
  print('setting schedule: ' + action.lectures.length.toString());
  return state.cloneAndUpdateValue("schedule", action.lectures);
}

AppState saveProfile(AppState state, SaveProfileAction action) {
  return state.cloneAndUpdateValue("profile", action.profile);
}

AppState saveCurrUcs(AppState state, SaveUcsAction action) {
  return state.cloneAndUpdateValue("currUcs", action.ucs);
}

AppState setPrintBalance(AppState state, SetPrintBalanceAction action) {
  print('setting print balance: ' + action.printBalance);
  return state.cloneAndUpdateValue("printBalance", action.printBalance);
}

AppState setFeesBalance(AppState state, SetFeesBalanceAction action) {
  print('setting fees balance: ' + action.feesBalance);
  return state.cloneAndUpdateValue("feesBalance", action.feesBalance);
}

AppState setFeesLimit(AppState state, SetFeesLimitAction action) {
  print('setting fees limit: ' + action.feesLimit);
  return state.cloneAndUpdateValue("feesLimit", action.feesLimit);
}