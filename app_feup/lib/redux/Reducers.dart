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
  } else if (action is SaveUcsAction) {
    return saveCurrUcs(state, action);
  } else if(action is SetPrintBalanceAction) {
    return setPrintBalance(state, action);
  } else if(action is SetFeesBalanceAction) {
    return setFeesBalance(state, action);
  } else if(action is SetFeesLimitAction) {
    return setFeesLimit(state, action);
  } else if(action is SetCoursesStatesAction){
    return setCoursesState(state, action);
  } else if(action is SetBusStopTripsAction){
    return setBusStopTrips(state, action);
  } else if(action is SetBusStopStatusAction){
    return setBusStopStatus(state, action);
  } else if(action is SetBusStopTimeStampAction){
    return setBusStopTimeStamp(state, action);
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
  print('setting next fees limit: ' + action.feesLimit);
  return state.cloneAndUpdateValue("feesLimit", action.feesLimit);
}

AppState setCoursesState(AppState state, SetCoursesStatesAction action) {
  print('setting courses state: ' + action.coursesStates.toString());
  return state.cloneAndUpdateValue("coursesStates", action.coursesStates);
}

AppState setBusStopTrips(AppState state, SetBusStopTripsAction action) {
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