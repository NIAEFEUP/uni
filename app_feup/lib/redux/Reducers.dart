
import '../model/AppState.dart';
import 'Actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SaveLoginDataAction) {
    return login(state, action);
  } else if (action is SetLoginStatusAction) {
    return setLoginStatus(state, action);
  } else if(action is UpdateSelectedPageAction) {
    return updateSelectedPageStatus(state, action);
  } else if (action is SetExamsAction) {
    return setExams(state, action);
  } else if (action is SetExamsStatusAction) {
    return setExamsStatus(state, action);
  } else if (action is SetScheduleStatusAction) {
    return setScheduleStatus(state, action);
  } else if (action is SetScheduleAction) {
    return setSchedule(state, action);
  } else if (action is SaveProfileAction) {
    return saveProfile(state, action);
  } else if (action is SaveProfileStatusAction) {
    return saveProfileStatus(state, action);
  } else if (action is SaveUcsAction) {
    return saveCurrUcs(state, action);
  } else if(action is SetPrintBalanceAction) {
    return setPrintBalance(state, action);
  } else if(action is SetPrintBalanceStatusAction) {
    return setPrintBalanceStatus(state, action);
  } else if(action is SetFeesBalanceAction) {
    return setFeesBalance(state, action);
  } else if(action is SetFeesLimitAction) {
    return setFeesLimit(state, action);
  } else if(action is SetFeesStatusAction) {
    return setFeesStatus(state, action);
  } else if(action is SetCoursesStatesAction){
    return setCoursesState(state, action);
  } else if(action is SetCoursesStatesStatusAction){
    return setCoursesStateStatus(state, action);
  } else if (action is SetPrintRefreshTimeAction) {
    return setPrintRefreshTime(state, action);
  } else if (action is SetFeesRefreshTimeAction) {
    return setFeesRefreshTime(state, action);
  }
  return state;
}

AppState updateSelectedPageStatus(AppState state, UpdateSelectedPageAction action) {
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

AppState setExamsStatus(AppState state, SetExamsStatusAction action) {
  print('setting exams status: ' + action.status.toString());
  return state.cloneAndUpdateValue('examsStatus', action.status);
}

AppState setSchedule(AppState state, SetScheduleAction action) {
  print('setting schedule: ' + action.lectures.length.toString());
  return state.cloneAndUpdateValue("schedule", action.lectures);
}

AppState setScheduleStatus(AppState state, SetScheduleStatusAction action) {
  print('setting schedule status: ' + action.status.toString());
  return state.cloneAndUpdateValue('scheduleStatus', action.status);
}

AppState saveProfile(AppState state, SaveProfileAction action) {
  return state.cloneAndUpdateValue("profile", action.profile);
}

AppState saveProfileStatus(AppState state, SaveProfileStatusAction action) {
  print('setting profile status: ' + action.status.toString());
  return state.cloneAndUpdateValue("profileStatus", action.status);
}

AppState saveCurrUcs(AppState state, SaveUcsAction action) {
  return state.cloneAndUpdateValue("currUcs", action.ucs);
}

AppState setPrintBalance(AppState state, SetPrintBalanceAction action) {
  print('setting print balance: ' + action.printBalance);
  return state.cloneAndUpdateValue("printBalance", action.printBalance);
}

AppState setPrintBalanceStatus(AppState state, SetPrintBalanceStatusAction action) {
  print('setting print balance status: ' + action.status.toString());
  return state.cloneAndUpdateValue("printBalanceStatus", action.status);
}

AppState setFeesBalance(AppState state, SetFeesBalanceAction action) {
  print('setting fees balance: ' + action.feesBalance);
  return state.cloneAndUpdateValue("feesBalance", action.feesBalance);
}

AppState setFeesLimit(AppState state, SetFeesLimitAction action) {
  print('setting next fees limit: ' + action.feesLimit);
  return state.cloneAndUpdateValue("feesLimit", action.feesLimit);
}

AppState setFeesStatus(AppState state, SetFeesStatusAction action) {
  print('setting fees status: ' + action.status.toString());
  return state.cloneAndUpdateValue("feesStatus", action.status);
}

AppState setCoursesState(AppState state, SetCoursesStatesAction action) {
  print('setting courses state: ' + action.coursesStates.toString());
  return state.cloneAndUpdateValue("coursesStates", action.coursesStates);
}

AppState setCoursesStateStatus(AppState state, SetCoursesStatesStatusAction action) {
  print('setting courses state status: ' + action.status.toString());
  return state.cloneAndUpdateValue("coursesStatesStatus", action.status);
}

AppState setPrintRefreshTime(AppState state, SetPrintRefreshTimeAction action) {
  print('setting print refresh time ' + action.time);
  return state.cloneAndUpdateValue("printRefreshTime", action.time);
}

AppState setFeesRefreshTime(AppState state, SetFeesRefreshTimeAction action) {
  print('setting fees refresh time ' + action.time);
  return state.cloneAndUpdateValue("feesRefreshTime", action.time);
}

