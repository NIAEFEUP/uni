import 'dart:async';
import 'package:uni/controller/LoadInfo.dart';
import 'package:uni/controller/local_storage/AppBusStopDatabase.dart';
import 'package:uni/controller/local_storage/AppCoursesDatabase.dart';
import 'package:uni/controller/local_storage/AppExamsDatabase.dart';
import 'package:uni/controller/local_storage/AppLastUserInfoUpdateDatabase.dart';
import 'package:uni/controller/local_storage/AppLecturesDatabase.dart';
import 'package:uni/controller/local_storage/AppRefreshTimesDatabase.dart';
import 'package:uni/controller/local_storage/AppSharedPreferences.dart';
import 'package:uni/controller/local_storage/AppUserDataDatabase.dart';
import 'package:uni/controller/parsers/ParserExams.dart';
import 'package:uni/controller/parsers/ParserSchedule.dart';
import 'package:uni/controller/parsers/ParserPrintBalance.dart';
import 'package:uni/controller/parsers/ParserFees.dart';
import 'package:uni/controller/parsers/ParserCourses.dart';
import 'package:uni/model/entities/Course.dart';
import 'package:uni/model/entities/CourseUnit.dart';
import 'package:uni/model/entities/Exam.dart';
import 'package:uni/model/entities/Lecture.dart';
import 'package:uni/model/entities/Profile.dart';
import 'package:uni/model/entities/Session.dart';
import 'package:uni/model/entities/Trip.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:tuple/tuple.dart';
import '../model/AppState.dart';
import '../model/entities/BusStop.dart';
import 'Actions.dart';
import 'package:redux/redux.dart';
import 'package:uni/controller/networking/NetworkRouter.dart';

ThunkAction<AppState> reLogin(username, password, faculty, {Completer action}) {
  return (Store<AppState> store) async {
    try {
      loadLocalUserInfoToState(store);
      store.dispatch(new SetLoginStatusAction(RequestStatus.BUSY));
      final Session session =
          await NetworkRouter.login(username, password, faculty, true);
      store.dispatch(new SaveLoginDataAction(session));
      if (session.authenticated) {
        await loadRemoteUserInfoToState(store);
        store.dispatch(new SetLoginStatusAction(RequestStatus.SUCCESSFUL));
        action?.complete();
      } else {
        store.dispatch(new SetLoginStatusAction(RequestStatus.FAILED));
        action?.completeError(RequestStatus.FAILED);
      }
    } catch (e) {
      final Session renew_session = Session(studentNumber: username, authenticated: false);
      renew_session.persistentSession = true;
      renew_session.faculty = faculty;

      action?.completeError(RequestStatus.FAILED);

      store.dispatch(new SaveLoginDataAction(renew_session));
      store.dispatch(new SetLoginStatusAction(RequestStatus.FAILED));
    }
  };
}

ThunkAction<AppState> login(username, password, faculty, persistentSession, usernameController, passwordController) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new SetLoginStatusAction(RequestStatus.BUSY));
      final Session session = await NetworkRouter.login(
          username, password, faculty, persistentSession);
      store.dispatch(new SaveLoginDataAction(session));
      if (session.authenticated) {
        store.dispatch(new SetLoginStatusAction(RequestStatus.SUCCESSFUL));
        await loadUserInfoToState(store);
        if (persistentSession)
          AppSharedPreferences.savePersistentUserInfo(username, password);
        usernameController.clear();
        passwordController.clear();
      } else {
        store.dispatch(new SetLoginStatusAction(RequestStatus.FAILED));
      }
    } catch (e) {
      store.dispatch(new SetLoginStatusAction(RequestStatus.FAILED));
    }
  };
}

ThunkAction<AppState> getUserInfo(Completer<Null> action) {
  return (Store<AppState> store) async {
    try {
      Profile user_profile;

      store.dispatch(SaveProfileStatusAction(RequestStatus.BUSY));

      final profile =
          NetworkRouter.getProfile(store.state.content['session']).then((res) {
        user_profile = res;
        store.dispatch(new SaveProfileAction(user_profile));
        store.dispatch(new SaveProfileStatusAction(RequestStatus.SUCCESSFUL));
      });
      final ucs =
          NetworkRouter.getCurrentCourseUnits(store.state.content['session'])
              .then((res) => store.dispatch(new SaveUcsAction(res)));
      await Future.wait([profile, ucs]);

      Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
        AppUserDataDatabase profile_db = await AppUserDataDatabase();
        await profile_db.saveUserData(user_profile);

        AppCoursesDatabase courses_db = await AppCoursesDatabase();
        await courses_db.saveNewCourses(user_profile.courses);
      }
    } catch (e) {
      print("Failed to get User Info");
      store.dispatch(new SaveProfileStatusAction(RequestStatus.FAILED));
    }

    action.complete();
  };
}

ThunkAction<AppState> updateStateBasedOnLocalUserExams() {
  return (Store<AppState> store) async {
    AppExamsDatabase db = await AppExamsDatabase();
    List<Exam> exs = await db.exams();
    store.dispatch(new SetExamsAction(exs));
  };
}

ThunkAction<AppState> updateStateBasedOnLocalUserLectures() {
  return (Store<AppState> store) async {
    AppLecturesDatabase db = await AppLecturesDatabase();
    List<Lecture> lecs = await db.lectures();
    store.dispatch(new SetScheduleAction(lecs));
  };
}

ThunkAction<AppState> updateStateBasedOnLocalProfile() {
  return (Store<AppState> store) async {
    AppUserDataDatabase profile_db = await AppUserDataDatabase();
    Profile profile = await profile_db.userdata();

    AppCoursesDatabase courses_db = await AppCoursesDatabase();
    List<Course> courses = await courses_db.courses();

    profile.courses = courses;

    // Build courses states map
    Map<String, String> coursesStates = new Map<String, String>();
    for (Course course in profile.courses) {
      coursesStates[course.name] = course.state;
    }

    store.dispatch(new SaveProfileAction(profile));
    store.dispatch(new SetPrintBalanceAction(profile.printBalance));
    store.dispatch(new SetFeesBalanceAction(profile.feesBalance));
    store.dispatch(new SetFeesLimitAction(profile.feesLimit));
    store.dispatch(new SetCoursesStatesAction(coursesStates));
  };
}

ThunkAction<AppState> updateStateBasedOnLocalUserBusStops() {
  return (Store<AppState> store) async {
    AppBusStopDatabase bus_stops_db = await AppBusStopDatabase();
    Map<String, BusStopData> stops = await bus_stops_db.busStops();

    store.dispatch(new SetBusStopsAction(stops));
    store.dispatch(getUserBusTrips(new Completer()));
  };
}

ThunkAction<AppState> updateStateBasedOnLocalRefreshTimes() {
  return (Store<AppState> store) async {
    AppRefreshTimesDatabase refresh_times_db = await AppRefreshTimesDatabase();
    Map<String, String> refreshTimes = await refresh_times_db.refreshTimes();

    store.dispatch(new SetPrintRefreshTimeAction(refreshTimes["print"]));
    store.dispatch(new SetFeesRefreshTimeAction(refreshTimes["fees"]));
  };
}

ThunkAction<AppState> getUserExams(Completer<Null> action) {
  return (Store<AppState> store) async {
    try {
      //need to get student course here
      store.dispatch(new SetExamsStatusAction(RequestStatus.BUSY));

      List<Exam> courseExams = new List<Exam>();

      for (Course course in store.state.content['profile'].courses) {
        List<Exam> currentCourseExams = await parseExams(
            await NetworkRouter.getWithCookies(
                NetworkRouter.getBaseUrlFromSession(
                        store.state.content['session']) +
                    "exa_geral.mapa_de_exames?p_curso_id=${course.id}",
                {},
                store.state.content['session']));
        courseExams = new List.from(courseExams)..addAll(currentCourseExams);
      }
      
      final DateTime now = new DateTime.now();

      List<CourseUnit> userUcs = store.state.content['currUcs'];
      List<Exam> exams = new List<Exam>();
      for (Exam courseExam in courseExams) {
        for (CourseUnit uc in userUcs) {
          if (!courseExam.examType.contains(
                  "Exames ao abrigo de estatutos especiais - Port.Est.Especiais") &&
              courseExam.subject == uc.abbreviation &&
              now.compareTo(courseExam.date) <= 0
              ) {
            exams.add(courseExam);
            break;
          }
        }
      }

      // Updates local database according to the information fetched -- Exams
      Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
        AppExamsDatabase db = await AppExamsDatabase();
        db.saveNewExams(exams);
      }
      store.dispatch(new SetExamsStatusAction(RequestStatus.SUCCESSFUL));
      store.dispatch(new SetExamsAction(exams));
    } catch (e) {
      print("Failed to get Exams");
      store.dispatch(new SetExamsStatusAction(RequestStatus.FAILED));
    }

    action.complete();
  };
}

ThunkAction<AppState> getUserSchedule(Completer<Null> action) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new SetScheduleStatusAction(RequestStatus.BUSY));
      var date = DateTime.now();
      String beginWeek = date.year.toString().padLeft(4, '0') +
          date.month.toString().padLeft(2, '0') +
          date.day.toString().padLeft(2, '0');
      date = date.add(new Duration(days: 6));

      String endWeek = date.year.toString().padLeft(4, '0') +
          date.month.toString().padLeft(2, '0') +
          date.day.toString().padLeft(2, '0');

      List<Lecture> lectures = await parseSchedule(
          await NetworkRouter.getWithCookies(
              NetworkRouter.getBaseUrlFromSession(
                      store.state.content['session']) +
                  "mob_hor_geral.estudante?pv_codigo=${store.state.content['session'].studentNumber}"
                      "&pv_semana_ini=$beginWeek&pv_semana_fim=$endWeek",
              {},
              store.state.content['session']));

      // Updates local database according to the information fetched -- Lectures
      Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
        AppLecturesDatabase db = await AppLecturesDatabase();
        db.saveNewLectures(lectures);
      }

      store.dispatch(new SetScheduleAction(lectures));
      store.dispatch(new SetScheduleStatusAction(RequestStatus.SUCCESSFUL));
    } catch (e) {
      print("Failed to get Schedule");
      store.dispatch(new SetScheduleStatusAction(RequestStatus.FAILED));
    }
    action.complete();
  };
}

ThunkAction<AppState> setInitialStoreState() {
  return (Store<AppState> store) async {
    store.dispatch(new SetInitialStoreStateAction());
  };
}

ThunkAction<AppState> getUserPrintBalance(Completer<Null> action) {
  return (Store<AppState> store) async {
    String url =
        NetworkRouter.getBaseUrlFromSession(store.state.content['session']) +
            "imp4_impressoes.atribs?";

    Map<String, String> query = {
      "p_codigo": store.state.content['session'].studentNumber
    };

    try {
      var response = await NetworkRouter.getWithCookies(url, query, store.state.content['session']);
      String printBalance = await getPrintsBalance(response);

      String current_time = DateTime.now().toString();
      Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
        await storeRefreshTime("print", current_time);

        // Store fees info
        AppUserDataDatabase profile_db = await AppUserDataDatabase();
        await profile_db.saveUserPrintBalance(printBalance);
      }

      store.dispatch(new SetPrintBalanceAction(printBalance));
      store.dispatch(new SetPrintBalanceStatusAction(RequestStatus.SUCCESSFUL));
      store.dispatch(new SetPrintRefreshTimeAction(current_time));
    } catch (e) {
      print("Failed to get Print Balance");
      store.dispatch(new SetPrintBalanceStatusAction(RequestStatus.FAILED));
    }
    action.complete();
  };
}

ThunkAction<AppState> getUserFees(Completer<Null> action) {
  return (Store<AppState> store) async {
    store.dispatch(new SetFeesStatusAction(RequestStatus.BUSY));

    String url =
        NetworkRouter.getBaseUrlFromSession(store.state.content['session']) +
            "gpag_ccorrente_geral.conta_corrente_view?";

    Map<String, String> query = {
      "pct_cod": store.state.content['session'].studentNumber
    };

    try {
      var response = await NetworkRouter.getWithCookies(url, query, store.state.content['session']);

      String feesBalance = await parseFeesBalance(response);
      String feesLimit = await parseFeesNextLimit(response);

      String current_time = DateTime.now().toString();
      Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
        await storeRefreshTime("fees", current_time);

        // Store fees info
        AppUserDataDatabase profile_db = await AppUserDataDatabase();
        await profile_db
            .saveUserFees(new Tuple2<String, String>(feesBalance, feesLimit));
      }

      store.dispatch(new SetFeesBalanceAction(feesBalance));
      store.dispatch(new SetFeesLimitAction(feesLimit));
      store.dispatch(new SetFeesStatusAction(RequestStatus.SUCCESSFUL));
      store.dispatch(new SetFeesRefreshTimeAction(current_time));
    } catch (e) {
      print("Failed to get Fees info");
      store.dispatch(new SetFeesStatusAction(RequestStatus.FAILED));
    }

    action.complete();
  };
}

ThunkAction<AppState> getUserCoursesState(Completer<Null> action) {
  return (Store<AppState> store) async {
    store.dispatch(SetCoursesStatesStatusAction(RequestStatus.BUSY));

    String url =
        NetworkRouter.getBaseUrlFromSession(store.state.content['session']) +
            "fest_geral.cursos_list?";

    Map<String, String> query = {
      "pv_num_unico": store.state.content['session'].studentNumber
    };

    try {
      var response = await NetworkRouter.getWithCookies(url, query, store.state.content['session']);

      Map<String, String> coursesStates = await parseCourses(response);

      Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != "" && userPersistentInfo.item2 != "") {
        AppCoursesDatabase courses_db = await AppCoursesDatabase();
        await courses_db.saveCoursesStates(coursesStates);
      }
      store.dispatch(new SetCoursesStatesAction(coursesStates));
      store.dispatch(SetCoursesStatesStatusAction(RequestStatus.SUCCESSFUL));
    } catch (e) {
      print("Failed to get Courses State info");
      store.dispatch(SetCoursesStatesStatusAction(RequestStatus.FAILED));
    }

    action.complete();
  };
}

ThunkAction<AppState> getUserBusTrips(Completer<Null> action){
  return(Store<AppState> store) async{
    store.dispatch(new SetBusTripsStatusAction(RequestStatus.BUSY));
    try {
      Map<String, BusStopData> stops = store.state.content['configuredBusStops'];
      Map<String, List<Trip>> trips = new Map<String, List<Trip>>();

      for(String stopCode in stops.keys){
        List<Trip> stopTrips = await NetworkRouter.getNextArrivalsStop(stopCode, stops[stopCode]);
        trips[stopCode] = stopTrips;
      }

      DateTime time = new DateTime.now();

      store.dispatch(new SetBusTripsAction(trips));
      store.dispatch(new SetBusStopTimeStampAction(time));
      store.dispatch(new SetBusTripsStatusAction(RequestStatus.SUCCESSFUL));
    } catch(e) {
      print("Failed to get Bus Stop information");
      store.dispatch(new SetBusTripsStatusAction(RequestStatus.FAILED));
    }

    action.complete();
  };
}

ThunkAction<AppState> addUserBusStop(Completer<Null> action, String stopCode, BusStopData stopData){
  return(Store<AppState> store){
    store.dispatch(new SetBusTripsStatusAction(RequestStatus.BUSY));
    Map<String, BusStopData> stops = store.state.content['configuredBusStops'];

    if(stops.containsKey(stopCode))
      stops[stopCode].configuredBuses.addAll(stopData.configuredBuses);
    else
      stops[stopCode] = stopData;
    store.dispatch(SetBusStopsAction(stops));
    store.dispatch(getUserBusTrips(action));

    AppBusStopDatabase db = AppBusStopDatabase();
    db.setBusStops(stops);
  };
}

ThunkAction<AppState> removeUserBusStop(Completer<Null> action, String stopCode){
  return(Store<AppState> store) {
    store.dispatch(new SetBusTripsStatusAction(RequestStatus.BUSY));
    Map<String,BusStopData> stops = store.state.content['configuredBusStops'];
    stops.remove(stopCode);

    store.dispatch(SetBusStopsAction(stops));
    store.dispatch(getUserBusTrips(action));

    AppBusStopDatabase db = AppBusStopDatabase();
    db.setBusStops(stops);
  };
}

ThunkAction<AppState> toggleFavoriteUserBusStop(Completer<Null> action, String stopCode, BusStopData stopData) {
  return(Store<AppState> store) {
    Map<String, BusStopData> stops = store.state.content['configuredBusStops'];

    stops[stopCode].favorited = !stops[stopCode].favorited;

    store.dispatch(getUserBusTrips(action));

    AppBusStopDatabase db = AppBusStopDatabase();
    db.updateFavoriteBusStop(stopCode);
  };
}

Future storeRefreshTime(String db, String current_time) async {
  AppRefreshTimesDatabase refreshTimesDatabase =
      await AppRefreshTimesDatabase();
  await refreshTimesDatabase.saveRefreshTime(db, current_time);
}
ThunkAction<AppState> setLastUserInfoUpdateTimestamp(Completer<Null> action){
  return (Store<AppState> store) async{
    DateTime currentTime = DateTime.now();
    store.dispatch(new SetLastUserInfoUpdateTime(currentTime));
    AppLastUserInfoUpdateDatabase db = await AppLastUserInfoUpdateDatabase();
    await db.insertNewTimeStamp(currentTime);
    action.complete();
  };
}

ThunkAction<AppState> updateStateBasedOnLocalTime(){
  return (Store<AppState> store) async{
    AppLastUserInfoUpdateDatabase db = await AppLastUserInfoUpdateDatabase();
    DateTime savedTime = await db.getLastUserInfoUpdateTime();
    store.dispatch(new SetLastUserInfoUpdateTime(savedTime));
  };
}
