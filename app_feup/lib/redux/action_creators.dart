import 'dart:async';

import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/load_info.dart';
import 'package:uni/controller/load_static/terms_and_conditions.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/controller/local_storage/app_courses_database.dart';
import 'package:uni/controller/local_storage/app_exams_database.dart';
import 'package:uni/controller/local_storage/app_last_user_info_update_database.dart';
import 'package:uni/controller/local_storage/app_lectures_database.dart';
import 'package:uni/controller/local_storage/app_refresh_times_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/controller/local_storage/app_user_database.dart';
import 'package:uni/controller/local_storage/app_restaurant_database.dart';
import 'package:uni/controller/networking/network_router.dart'
    show NetworkRouter;
import 'package:uni/controller/parsers/parser_courses.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/controller/parsers/parser_fees.dart';
import 'package:uni/controller/parsers/parser_print_balance.dart';
import 'package:uni/controller/restaurant_fetcher/restaurant_fetcher_html.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher_api.dart';
import 'package:uni/controller/schedule_fetcher/schedule_fetcher_html.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/redux/actions.dart';

import '../model/entities/bus_stop.dart';

ThunkAction<AppState> reLogin(username, password, faculty, {Completer action}) {
  /// TODO: support for multiple faculties. Issue: #445
  return (Store<AppState> store) async {
    try {
      loadLocalUserInfoToState(store);
      store.dispatch(SetLoginStatusAction(RequestStatus.busy));
      final Session session =
          await NetworkRouter.login(username, password, faculty, true);
      store.dispatch(SaveLoginDataAction(session));
      if (session.authenticated) {
        await loadRemoteUserInfoToState(store);
        store.dispatch(SetLoginStatusAction(RequestStatus.successful));
        action?.complete();
      } else {
        store.dispatch(SetLoginStatusAction(RequestStatus.failed));
        action?.completeError(RequestStatus.failed);
      }
    } catch (e) {
      final Session renewSession =
          Session(studentNumber: username, authenticated: false);
      renewSession.persistentSession = true;
      renewSession.faculty = faculty;

      action?.completeError(RequestStatus.failed);

      store.dispatch(SaveLoginDataAction(renewSession));
      store.dispatch(SetLoginStatusAction(RequestStatus.failed));
    }
  };
}

ThunkAction<AppState> login(username, password, faculties, persistentSession,
    usernameController, passwordController) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(SetLoginStatusAction(RequestStatus.busy));

      /// TODO: support for multiple faculties. Issue: #445
      final Session session = await NetworkRouter.login(
          username, password, faculties[0], persistentSession);
      store.dispatch(SaveLoginDataAction(session));
      if (session.authenticated) {
        store.dispatch(SetLoginStatusAction(RequestStatus.successful));
        await loadUserInfoToState(store);

        /// Faculties chosen in the dropdown
        store.dispatch(SetUserFaculties(faculties));
        if (persistentSession) {
          AppSharedPreferences.savePersistentUserInfo(
              username, password, faculties);
        }
        usernameController.clear();
        passwordController.clear();
        await acceptTermsAndConditions();
      } else {
        store.dispatch(SetLoginStatusAction(RequestStatus.failed));
      }
    } catch (e) {
      store.dispatch(SetLoginStatusAction(RequestStatus.failed));
    }
  };
}

ThunkAction<AppState> getUserInfo(Completer<Null> action) {
  return (Store<AppState> store) async {
    try {
      Profile userProfile;

      store.dispatch(SaveProfileStatusAction(RequestStatus.busy));

      final profile =
          NetworkRouter.getProfile(store.state.content['session']).then((res) {
        userProfile = res;
        store.dispatch(SaveProfileAction(userProfile));
        store.dispatch(SaveProfileStatusAction(RequestStatus.successful));
      });
      final ucs =
          NetworkRouter.getCurrentCourseUnits(store.state.content['session'])
              .then((res) => store.dispatch(SaveUcsAction(res)));
      await Future.wait([profile, ucs]);

      final Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final profileDb = AppUserDataDatabase();
        profileDb.saveUserData(userProfile);

        final AppCoursesDatabase coursesDb = AppCoursesDatabase();
        await coursesDb.saveNewCourses(userProfile.courses);
      }
    } catch (e) {
      Logger().e('Failed to get User Info');
      store.dispatch(SaveProfileStatusAction(RequestStatus.failed));
    }

    action.complete();
  };
}

ThunkAction<AppState> updateStateBasedOnLocalUserExams() {
  return (Store<AppState> store) async {
    final AppExamsDatabase db = AppExamsDatabase();
    final List<Exam> exs = await db.exams();
    store.dispatch(SetExamsAction(exs));
  };
}

ThunkAction<AppState> updateStateBasedOnLocalUserLectures() {
  return (Store<AppState> store) async {
    final AppLecturesDatabase db = AppLecturesDatabase();
    final List<Lecture> lecs = await db.lectures();
    store.dispatch(SetScheduleAction(lecs));
  };
}

ThunkAction<AppState> updateStateBasedOnLocalProfile() {
  return (Store<AppState> store) async {
    final profileDb = AppUserDataDatabase();
    final Profile profile = await profileDb.userdata();

    final AppCoursesDatabase coursesDb = AppCoursesDatabase();
    final List<Course> courses = await coursesDb.courses();

    profile.courses = courses;

    // Build courses states map
    final Map<String, String> coursesStates = Map<String, String>();
    for (Course course in profile.courses) {
      coursesStates[course.name] = course.state;
    }

    store.dispatch(SaveProfileAction(profile));
    store.dispatch(SetPrintBalanceAction(profile.printBalance));
    store.dispatch(SetFeesBalanceAction(profile.feesBalance));
    store.dispatch(SetFeesLimitAction(profile.feesLimit));
    store.dispatch(SetCoursesStatesAction(coursesStates));
  };
}

ThunkAction<AppState> updateStateBasedOnLocalUserBusStops() {
  return (Store<AppState> store) async {
    final AppBusStopDatabase busStopsDb = AppBusStopDatabase();
    final Map<String, BusStopData> stops = await busStopsDb.busStops();

    store.dispatch(SetBusStopsAction(stops));
    store.dispatch(getUserBusTrips(Completer()));
  };
}

ThunkAction<AppState> updateStateBasedOnLocalRefreshTimes() {
  return (Store<AppState> store) async {
    final AppRefreshTimesDatabase refreshTimesDb = AppRefreshTimesDatabase();
    final Map<String, String> refreshTimes =
        await refreshTimesDb.refreshTimes();

    store.dispatch(SetPrintRefreshTimeAction(refreshTimes['print']));
    store.dispatch(SetFeesRefreshTimeAction(refreshTimes['fees']));
  };
}

Future<List<Exam>> extractExams(
    Store<AppState> store, ParserExams parserExams) async {
  Set<Exam> courseExams = Set();
  for (Course course in store.state.content['profile'].courses) {
    final Set<Exam> currentCourseExams = await parserExams.parseExams(
        await NetworkRouter.getWithCookies(
            NetworkRouter.getBaseUrlFromSession(
                    store.state.content['session']) +
                'exa_geral.mapa_de_exames?p_curso_id=${course.id}',
            {},
            store.state.content['session']));
    courseExams = Set.from(courseExams)..addAll(currentCourseExams);
  }

  final List<CourseUnit> userUcs = store.state.content['currUcs'];
  final Set<Exam> exams = Set();
  for (Exam courseExam in courseExams) {
    for (CourseUnit uc in userUcs) {
      if (!courseExam.examType.contains(
              '''Exames ao abrigo de estatutos especiais - Port.Est.Especiais''') &&
          courseExam.subject == uc.abbreviation &&
          courseExam.hasEnded()) {
        exams.add(courseExam);
        break;
      }
    }
  }

  return exams.toList();
}

ThunkAction<AppState> getUserExams(Completer<Null> action,
    ParserExams parserExams, Tuple2<String, String> userPersistentInfo) {
  return (Store<AppState> store) async {
    try {
      //need to get student course here
      store.dispatch(SetExamsStatusAction(RequestStatus.busy));

      final List<Exam> exams = await extractExams(store, parserExams);

      exams.sort((exam1, exam2) => exam1.date.compareTo(exam2.date));

      // Updates local database according to the information fetched -- Exams
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppExamsDatabase db = AppExamsDatabase();
        db.saveNewExams(exams);
      }
      store.dispatch(SetExamsStatusAction(RequestStatus.successful));
      store.dispatch(SetExamsAction(exams));
    } catch (e) {
      Logger().e('Failed to get Exams');
      store.dispatch(SetExamsStatusAction(RequestStatus.failed));
    }

    action.complete();
  };
}

ThunkAction<AppState> getUserSchedule(
    Completer<Null> action, Tuple2<String, String> userPersistentInfo,
    {ScheduleFetcher fetcher}) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(SetScheduleStatusAction(RequestStatus.busy));

      final List<Lecture> lectures =
          await getLecturesFromFetcherOrElse(fetcher, store);

      // Updates local database according to the information fetched -- Lectures
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppLecturesDatabase db = AppLecturesDatabase();
        db.saveNewLectures(lectures);
      }

      store.dispatch(SetScheduleAction(lectures));
      store.dispatch(SetScheduleStatusAction(RequestStatus.successful));
    } catch (e) {
      Logger().e('Failed to get Schedule: ${e.toString()}');
      store.dispatch(SetScheduleStatusAction(RequestStatus.failed));
    }
    action.complete();
  };
}

ThunkAction<AppState> getRestaurantsFromFetcher(Completer<Null> action) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(SetRestaurantsStatusAction(RequestStatus.busy));

      final List<Restaurant> restaurants =
          await RestaurantFetcherHtml().getRestaurants(store);
      // Updates local database according to information fetched -- Restaurants
      final RestaurantDatabase db = RestaurantDatabase();
      db.saveRestaurants(restaurants);
      db.restaurants(day: null);
      store.dispatch(SetRestaurantsAction(restaurants));
      store.dispatch(SetRestaurantsStatusAction(RequestStatus.successful));
    } catch (e) {
      Logger().e('Failed to get Restaurants: ${e.toString()}');
      store.dispatch(SetRestaurantsStatusAction(RequestStatus.failed));
    }
    action.complete();
  };
}

Future<List<Lecture>> getLecturesFromFetcherOrElse(
        ScheduleFetcher fetcher, Store<AppState> store) =>
    (fetcher?.getLectures(store)) ?? getLectures(store);

Future<List<Lecture>> getLectures(Store<AppState> store) {
  return ScheduleFetcherApi()
      .getLectures(store)
      .catchError((e) => ScheduleFetcherHtml().getLectures(store));
}

ThunkAction<AppState> setInitialStoreState() {
  return (Store<AppState> store) async {
    store.dispatch(SetInitialStoreStateAction());
  };
}

ThunkAction<AppState> getUserPrintBalance(Completer<Null> action) {
  return (Store<AppState> store) async {
    final String url =
        NetworkRouter.getBaseUrlFromSession(store.state.content['session']) +
            'imp4_impressoes.atribs?';

    final Map<String, String> query = {
      'p_codigo': store.state.content['session'].studentNumber
    };

    try {
      final response = await NetworkRouter.getWithCookies(
          url, query, store.state.content['session']);
      final String printBalance = await getPrintsBalance(response);

      final String currentTime = DateTime.now().toString();
      final Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        await storeRefreshTime('print', currentTime);

        // Store fees info
        final profileDb = AppUserDataDatabase();
        profileDb.saveUserPrintBalance(printBalance);
      }

      store.dispatch(SetPrintBalanceAction(printBalance));
      store.dispatch(SetPrintBalanceStatusAction(RequestStatus.successful));
      store.dispatch(SetPrintRefreshTimeAction(currentTime));
    } catch (e) {
      Logger().e('Failed to get Print Balance');
      store.dispatch(SetPrintBalanceStatusAction(RequestStatus.failed));
    }
    action.complete();
  };
}

ThunkAction<AppState> getUserFees(Completer<Null> action) {
  return (Store<AppState> store) async {
    store.dispatch(SetFeesStatusAction(RequestStatus.busy));

    final String url =
        NetworkRouter.getBaseUrlFromSession(store.state.content['session']) +
            'gpag_ccorrente_geral.conta_corrente_view?';

    final Map<String, String> query = {
      'pct_cod': store.state.content['session'].studentNumber
    };

    try {
      final response = await NetworkRouter.getWithCookies(
          url, query, store.state.content['session']);

      final String feesBalance = await parseFeesBalance(response);
      final String feesLimit = await parseFeesNextLimit(response);

      final String currentTime = DateTime.now().toString();
      final Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        await storeRefreshTime('fees', currentTime);

        // Store fees info
        final profileDb = AppUserDataDatabase();
        profileDb.saveUserFees(Tuple2<String, String>(feesBalance, feesLimit));
      }

      store.dispatch(SetFeesBalanceAction(feesBalance));
      store.dispatch(SetFeesLimitAction(feesLimit));
      store.dispatch(SetFeesStatusAction(RequestStatus.successful));
      store.dispatch(SetFeesRefreshTimeAction(currentTime));
    } catch (e) {
      Logger().e('Failed to get Fees info');
      store.dispatch(SetFeesStatusAction(RequestStatus.failed));
    }

    action.complete();
  };
}

ThunkAction<AppState> getUserCoursesState(Completer<Null> action) {
  return (Store<AppState> store) async {
    store.dispatch(SetCoursesStatesStatusAction(RequestStatus.busy));

    final String url =
        NetworkRouter.getBaseUrlFromSession(store.state.content['session']) +
            'fest_geral.cursos_list?';

    final Map<String, String> query = {
      'pv_num_unico': store.state.content['session'].studentNumber
    };

    try {
      final response = await NetworkRouter.getWithCookies(
          url, query, store.state.content['session']);

      final Map<String, String> coursesStates = await parseCourses(response);

      final Tuple2<String, String> userPersistentInfo =
          await AppSharedPreferences.getPersistentUserInfo();
      if (userPersistentInfo.item1 != '' && userPersistentInfo.item2 != '') {
        final AppCoursesDatabase coursesDb = AppCoursesDatabase();
        coursesDb.saveCoursesStates(coursesStates);
      }
      store.dispatch(SetCoursesStatesAction(coursesStates));
      store.dispatch(SetCoursesStatesStatusAction(RequestStatus.successful));
    } catch (e) {
      Logger().e('Failed to get Courses State info');
      store.dispatch(SetCoursesStatesStatusAction(RequestStatus.failed));
    }

    action.complete();
  };
}

ThunkAction<AppState> getUserBusTrips(Completer<Null> action) {
  return (Store<AppState> store) async {
    store.dispatch(SetBusTripsStatusAction(RequestStatus.busy));
    try {
      final Map<String, BusStopData> stops =
          store.state.content['configuredBusStops'];
      final Map<String, List<Trip>> trips = Map<String, List<Trip>>();

      for (String stopCode in stops.keys) {
        final List<Trip> stopTrips =
            await NetworkRouter.getNextArrivalsStop(stopCode, stops[stopCode]);
        trips[stopCode] = stopTrips;
      }

      final DateTime time = DateTime.now();

      store.dispatch(SetBusTripsAction(trips));
      store.dispatch(SetBusStopTimeStampAction(time));
      store.dispatch(SetBusTripsStatusAction(RequestStatus.successful));
    } catch (e) {
      Logger().e('Failed to get Bus Stop information');
      store.dispatch(SetBusTripsStatusAction(RequestStatus.failed));
    }

    action.complete();
  };
}

ThunkAction<AppState> addUserBusStop(
    Completer<Null> action, String stopCode, BusStopData stopData) {
  return (Store<AppState> store) {
    store.dispatch(SetBusTripsStatusAction(RequestStatus.busy));
    final Map<String, BusStopData> stops =
        store.state.content['configuredBusStops'];

    if (stops.containsKey(stopCode)) {
      (stops[stopCode].configuredBuses).clear();
      stops[stopCode].configuredBuses.addAll(stopData.configuredBuses);
    } else {
      stops[stopCode] = stopData;
    }
    store.dispatch(SetBusStopsAction(stops));
    store.dispatch(getUserBusTrips(action));

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.setBusStops(stops);
  };
}

ThunkAction<AppState> removeUserBusStop(
    Completer<Null> action, String stopCode) {
  return (Store<AppState> store) {
    store.dispatch(SetBusTripsStatusAction(RequestStatus.busy));
    final Map<String, BusStopData> stops =
        store.state.content['configuredBusStops'];
    stops.remove(stopCode);

    store.dispatch(SetBusStopsAction(stops));
    store.dispatch(getUserBusTrips(action));

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.setBusStops(stops);
  };
}

ThunkAction<AppState> toggleFavoriteUserBusStop(
    Completer<Null> action, String stopCode, BusStopData stopData) {
  return (Store<AppState> store) {
    final Map<String, BusStopData> stops =
        store.state.content['configuredBusStops'];

    stops[stopCode].favorited = !stops[stopCode].favorited;

    store.dispatch(getUserBusTrips(action));

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.updateFavoriteBusStop(stopCode);
  };
}

ThunkAction<AppState> setFilteredExams(
    Map<String, bool> newFilteredExams, Completer<Null> action) {
  return (Store<AppState> store) {
    Map<String, bool> filteredExams = store.state.content['filteredExams'];
    filteredExams = Map<String, bool>.from(newFilteredExams);
    store.dispatch(SetExamFilter(filteredExams));
    AppSharedPreferences.saveFilteredExams(filteredExams);

    action.complete();
  };
}

Future storeRefreshTime(String db, String currentTime) async {
  final AppRefreshTimesDatabase refreshTimesDatabase =
      AppRefreshTimesDatabase();
  refreshTimesDatabase.saveRefreshTime(db, currentTime);
}

ThunkAction<AppState> setLastUserInfoUpdateTimestamp(Completer<Null> action) {
  return (Store<AppState> store) async {
    final DateTime currentTime = DateTime.now();
    store.dispatch(SetLastUserInfoUpdateTime(currentTime));
    final AppLastUserInfoUpdateDatabase db = AppLastUserInfoUpdateDatabase();
    await db.insertNewTimeStamp(currentTime);
    action.complete();
  };
}

ThunkAction<AppState> updateStateBasedOnLocalTime() {
  return (Store<AppState> store) async {
    final AppLastUserInfoUpdateDatabase db = AppLastUserInfoUpdateDatabase();
    final DateTime savedTime = await db.getLastUserInfoUpdateTime();
    store.dispatch(SetLastUserInfoUpdateTime(savedTime));
  };
}
