import '../model/AppState.dart';
import 'Actions.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is SaveLoginDataAction) {
    return login(state, action);
  } else if (action is SetLoginStatusAction) {
    return setLoginStatus(state, action);
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
  } else if (action is SetPrintBalanceAction) {
    return setPrintBalance(state, action);
  } else if (action is SetPrintBalanceStatusAction) {
    return setPrintBalanceStatus(state, action);
  } else if (action is SetFeesBalanceAction) {
    return setFeesBalance(state, action);
  } else if (action is SetFeesLimitAction) {
    return setFeesLimit(state, action);
  } else if (action is SetFeesStatusAction) {
    return setFeesStatus(state, action);
  } else if (action is SetCoursesStatesAction) {
    return setCoursesState(state, action);
  } else if(action is SetBusStopAction){
    return setBusStop(state, action);
  } else if(action is SetBusStopStatusAction){
    return setBusStopStatus(state, action);
  } else if(action is SetBusStopTimeStampAction){
    return setBusStopTimeStamp(state, action);
  } else if(action is SetCurrentTimeAction){
    return setCurrentTime(state, action);
  } else if(action is UpdateFavoriteCards) {
    return updateFavoriteCards(state, action);
  } else if (action is SetCoursesStatesStatusAction) {
    return setCoursesStateStatus(state, action);
  } else if (action is SetPrintRefreshTimeAction) {
    return setPrintRefreshTime(state, action);
  } else if (action is SetFeesRefreshTimeAction) {
    return setFeesRefreshTime(state, action);
  } else if (action is SetInitialStoreStateAction) {
    return setInitialStoreState(state, action);
  } else if (action is SetHomePageEditingMode) {
    return setHomePageEditingMode(state, action);
  }
  return state;
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
  print('setting print balance: ' + action.printBalance.toString());
  return state.cloneAndUpdateValue("printBalance", action.printBalance);
}

AppState setPrintBalanceStatus(
    AppState state, SetPrintBalanceStatusAction action) {
  print('setting print balance status: ' + action.status.toString());
  return state.cloneAndUpdateValue("printBalanceStatus", action.status);
}

AppState setFeesBalance(AppState state, SetFeesBalanceAction action) {
  print('setting fees balance: ' + action.feesBalance.toString());
  return state.cloneAndUpdateValue("feesBalance", action.feesBalance);
}

AppState setFeesLimit(AppState state, SetFeesLimitAction action) {
  print('setting next fees limit: ' + action.feesLimit.toString());
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

AppState setBusStop(AppState state, SetBusStopAction action) {
  print('setting bus stops: ' + action.busStops.toString());
  return state.cloneAndUpdateValue("busstops", action.busStops);
}

AppState setBusStopStatus(AppState state, SetBusStopStatusAction action) {
  print('setting bus stop status: ' + action.status.toString());
  return state.cloneAndUpdateValue('busstopStatus', action.status);
}

AppState setBusStopTimeStamp(AppState state, SetBusStopTimeStampAction action){
  print('setting bus stop time stamp: ' + action.timeStamp.toString());
  return state.cloneAndUpdateValue('timeStamp', action.timeStamp);
}

AppState setCurrentTime(AppState state, SetCurrentTimeAction action) {
  print('setting bus stop time stamp: ' + action.currentTime.toString());
  return state.cloneAndUpdateValue('currentTime', action.currentTime);
}

AppState setInitialStoreState(
    AppState state, SetInitialStoreStateAction action) {
  print('setting initial store state');
  return state.getInitialState();
}

AppState updateFavoriteCards(AppState state, UpdateFavoriteCards action) {
  return state.cloneAndUpdateValue("favoriteCards", action.favoriteCards);
}

AppState setCoursesStateStatus(
    AppState state, SetCoursesStatesStatusAction action) {
  print('setting courses state status: ' + action.status.toString());
  return state.cloneAndUpdateValue("coursesStatesStatus", action.status);
}

AppState setPrintRefreshTime(AppState state, SetPrintRefreshTimeAction action) {
  print('setting print refresh time ' + action.time.toString());
  return state.cloneAndUpdateValue("printRefreshTime", action.time);
}

AppState setFeesRefreshTime(AppState state, SetFeesRefreshTimeAction action) {
  print('setting fees refresh time ' + action.time.toString());
  return state.cloneAndUpdateValue("feesRefreshTime", action.time);
}

AppState setHomePageEditingMode(AppState state, SetHomePageEditingMode action) {
  print('setting home page editing mode to ' + action.state.toString());
  return state.cloneAndUpdateValue("homePageEditingMode", action.state);
}
