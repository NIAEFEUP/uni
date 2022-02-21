import 'package:logger/logger.dart';
import 'package:uni/model/app_state.dart';

import 'actions.dart';

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
  } else if (action is SetBusTripsAction) {
    return setBusTrips(state, action);
  } else if (action is SetBusStopsAction) {
    return setBusStop(state, action);
  } else if (action is SetBusTripsStatusAction) {
    return setBusStopStatus(state, action);
  } else if (action is SetBusStopTimeStampAction) {
    return setBusStopTimeStamp(state, action);
  } else if (action is SetCurrentTimeAction) {
    return setCurrentTime(state, action);
  } else if (action is UpdateFavoriteCards) {
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
  } else if (action is SetLastUserInfoUpdateTime) {
    return setLastUserInfoUpdateTime(state, action);
  } else if (action is SetExamFilter) {
    return setExamFilter(state, action);
  } else if (action is SetUserFaculties) {
    return setUserFaculties(state, action);
  } else if(action is SetRestaurantsAction){
    return setRestaurantsAction(state, action);
  }
  return state;
}

AppState login(AppState state, SaveLoginDataAction action) {
  Logger().i('setting state: ' + action.session.toString());
  return state.cloneAndUpdateValue('session', action.session);
}

AppState setLoginStatus(AppState state, SetLoginStatusAction action) {
  Logger().i('setting login status: ' + action.status.toString());
  return state.cloneAndUpdateValue('loginStatus', action.status);
}

AppState setExams(AppState state, SetExamsAction action) {
  Logger().i('setting exams: ' + action.exams.length.toString());
  return state.cloneAndUpdateValue('exams', action.exams);
}

AppState setRestaurantsAction(AppState state, SetRestaurantsAction action) {
  Logger().i('setting restaurants: ' + action.restaurants.length.toString());
  return state.cloneAndUpdateValue('restaurants', action.restaurants);
}

AppState setExamsStatus(AppState state, SetExamsStatusAction action) {
  Logger().i('setting exams status: ' + action.status.toString());
  return state.cloneAndUpdateValue('examsStatus', action.status);
}

AppState setSchedule(AppState state, SetScheduleAction action) {
  Logger().i('setting schedule: ' + action.lectures.length.toString());
  return state.cloneAndUpdateValue('schedule', action.lectures);
}

AppState setScheduleStatus(AppState state, SetScheduleStatusAction action) {
  Logger().i('setting schedule status: ' + action.status.toString());
  return state.cloneAndUpdateValue('scheduleStatus', action.status);
}

AppState saveProfile(AppState state, SaveProfileAction action) {
  return state.cloneAndUpdateValue('profile', action.profile);
}

AppState saveProfileStatus(AppState state, SaveProfileStatusAction action) {
  Logger().i('setting profile status: ' + action.status.toString());
  return state.cloneAndUpdateValue('profileStatus', action.status);
}

AppState saveCurrUcs(AppState state, SaveUcsAction action) {
  return state.cloneAndUpdateValue('currUcs', action.ucs);
}

AppState setPrintBalance(AppState state, SetPrintBalanceAction action) {
  Logger().i('setting print balance: ' + action.printBalance.toString());
  return state.cloneAndUpdateValue('printBalance', action.printBalance);
}

AppState setPrintBalanceStatus(
    AppState state, SetPrintBalanceStatusAction action) {
  Logger().i('setting print balance status: ' + action.status.toString());
  return state.cloneAndUpdateValue('printBalanceStatus', action.status);
}

AppState setFeesBalance(AppState state, SetFeesBalanceAction action) {
  Logger().i('setting fees balance: ' + action.feesBalance.toString());
  return state.cloneAndUpdateValue('feesBalance', action.feesBalance);
}

AppState setFeesLimit(AppState state, SetFeesLimitAction action) {
  Logger().i('setting next fees limit: ' + action.feesLimit.toString());
  return state.cloneAndUpdateValue('feesLimit', action.feesLimit);
}

AppState setFeesStatus(AppState state, SetFeesStatusAction action) {
  Logger().i('setting fees status: ' + action.status.toString());
  return state.cloneAndUpdateValue('feesStatus', action.status);
}

AppState setCoursesState(AppState state, SetCoursesStatesAction action) {
  Logger().i('setting courses state: ' + action.coursesStates.toString());
  return state.cloneAndUpdateValue('coursesStates', action.coursesStates);
}

AppState setBusStop(AppState state, SetBusStopsAction action) {
  Logger().i('setting bus stops: ' + action.busStops.toString());
  return state.cloneAndUpdateValue('configuredBusStops', action.busStops);
}

AppState setBusTrips(AppState state, SetBusTripsAction action) {
  Logger().i('setting bus trips: ' + action.trips.toString());
  return state.cloneAndUpdateValue('currentBusTrips', action.trips);
}

AppState setBusStopStatus(AppState state, SetBusTripsStatusAction action) {
  Logger().i('setting bus stop status: ' + action.status.toString());
  return state.cloneAndUpdateValue('busstopStatus', action.status);
}

AppState setBusStopTimeStamp(AppState state, SetBusStopTimeStampAction action) {
  Logger().i('setting bus stop time stamp: ' + action.timeStamp.toString());
  return state.cloneAndUpdateValue('timeStamp', action.timeStamp);
}

AppState setCurrentTime(AppState state, SetCurrentTimeAction action) {
  Logger().i('setting bus stop time stamp: ' + action.currentTime.toString());
  return state.cloneAndUpdateValue('currentTime', action.currentTime);
}

AppState setInitialStoreState(
    AppState state, SetInitialStoreStateAction action) {
  Logger().i('setting initial store state');
  return state.getInitialState();
}

AppState updateFavoriteCards(AppState state, UpdateFavoriteCards action) {
  return state.cloneAndUpdateValue('favoriteCards', action.favoriteCards);
}

AppState setCoursesStateStatus(
    AppState state, SetCoursesStatesStatusAction action) {
  Logger().i('setting courses state status: ' + action.status.toString());
  return state.cloneAndUpdateValue('coursesStatesStatus', action.status);
}

AppState setPrintRefreshTime(AppState state, SetPrintRefreshTimeAction action) {
  Logger().i('setting print refresh time ' + action.time.toString());
  return state.cloneAndUpdateValue('printRefreshTime', action.time);
}

AppState setFeesRefreshTime(AppState state, SetFeesRefreshTimeAction action) {
  Logger().i('setting fees refresh time ' + action.time.toString());
  return state.cloneAndUpdateValue('feesRefreshTime', action.time);
}

AppState setHomePageEditingMode(AppState state, SetHomePageEditingMode action) {
  Logger().i('setting home page editing mode to ' + action.state.toString());
  return state.cloneAndUpdateValue('homePageEditingMode', action.state);
}

AppState setLastUserInfoUpdateTime(
    AppState state, SetLastUserInfoUpdateTime action) {
  return state.cloneAndUpdateValue(
      'lastUserInfoUpdateTime', action.currentTime);
}

AppState setExamFilter(AppState state, SetExamFilter action) {
  Logger().i('setting exam type filter to ' + action.filteredExams.toString());
  return state.cloneAndUpdateValue('filteredExams', action.filteredExams);
}

AppState setUserFaculties(AppState state, SetUserFaculties action) {
  Logger().i('setting user faculty(ies) ' + action.faculties.toString());
  return state.cloneAndUpdateValue('userFaculties', action.faculties);
}
