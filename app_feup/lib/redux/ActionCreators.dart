import 'dart:async';
import 'package:app_feup/controller/LoadInfo.dart';
import 'package:app_feup/controller/local_storage/AppCoursesDatabase.dart';
import 'package:app_feup/controller/local_storage/AppExamsDatabase.dart';
import 'package:app_feup/controller/local_storage/AppLecturesDatabase.dart';
import 'package:app_feup/controller/local_storage/AppSharedPreferences.dart';
import 'package:app_feup/controller/local_storage/AppUserDataDatabase.dart';
import 'package:app_feup/controller/parsers/ParserExams.dart';
import 'package:app_feup/controller/parsers/ParserSchedule.dart';
import 'package:app_feup/controller/parsers/ParserPrintBalance.dart';
import 'package:app_feup/controller/parsers/ParserFees.dart';
import 'package:app_feup/controller/parsers/ParserCourses.dart';
import 'package:app_feup/model/entities/CourseUnit.dart';
import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/model/entities/Lecture.dart';
import 'package:app_feup/model/entities/Profile.dart';
import 'package:app_feup/model/entities/Session.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:tuple/tuple.dart';
import '../model/AppState.dart';
import 'Actions.dart';
import 'package:redux/redux.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';

ThunkAction<AppState> reLogin(username, password, faculty) {
  return (Store<AppState> store) async {
    try {
      loadLocalUserInfoToState(store);
      store.dispatch(new SetLoginStatusAction(RequestStatus.BUSY));
      final Session session = await NetworkRouter.login(username, password, faculty, true);
      store.dispatch(new SaveLoginDataAction(session));
      if (session.authenticated){
        loadRemoteUserInfoToState(store);
        store.dispatch(new SetLoginStatusAction(RequestStatus.SUCCESSFUL));
      } else {
        store.dispatch(new SetLoginStatusAction(RequestStatus.FAILED));
      }
    } catch (e) {
      store.dispatch(new SetLoginStatusAction(RequestStatus.FAILED));
    }
  };
}

ThunkAction<AppState> login(username, password, faculty, persistentSession) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new SetLoginStatusAction(RequestStatus.BUSY));
      final Session session = await NetworkRouter.login(username, password, faculty, persistentSession);
      store.dispatch(new SaveLoginDataAction(session));
      if (session.authenticated){
        if (persistentSession)
          AppSharedPreferences.savePersistentUserInfo(username, password);
        await loadRemoteUserInfoToState(store);
        store.dispatch(new SetLoginStatusAction(RequestStatus.SUCCESSFUL));
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

      final profile = NetworkRouter.getProfile(store.state.content['session']).then((res) {
        user_profile = res;
        store.dispatch(new SaveProfileStatusAction(RequestStatus.SUCCESSFUL));
        store.dispatch(new SaveProfileAction(res));
      });
      final ucs = NetworkRouter.getCurrentCourseUnits(store.state.content['session']).then((res) => store.dispatch(new SaveUcsAction(res)));
      await Future.wait([profile, ucs]);

      Tuple2<String, String> userPersistentInfo = await AppSharedPreferences.getPersistentUserInfo();
      if(userPersistentInfo.item1 != "" && userPersistentInfo.item2 != ""){
        AppUserDataDatabase profile_db = await AppUserDataDatabase();
        profile_db.saveUserData(user_profile);

        AppCoursesDatabase courses_db = await AppCoursesDatabase();
        courses_db.saveNewCourses(user_profile.courses);
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
    store.dispatch(new SaveProfileAction(profile));
  };
}

ThunkAction<AppState> getUserExams(Completer<Null> action) {
  return (Store<AppState> store) async {
    try {
      //need to get student course here
      store.dispatch(new SetExamsStatusAction(RequestStatus.BUSY));

      List<Exam> courseExams = await parseExams(
          await NetworkRouter.getWithCookies(NetworkRouter.getBaseUrlFromSession(store.state.content['session']) + "exa_geral.mapa_de_exames?p_curso_id=742",
          {}, store.state.content['session'].cookies)
      );

      List<CourseUnit> userUcs = store.state.content['currUcs'];
      List<Exam> exams = new List<Exam>();
      for (Exam courseExam in courseExams) {
        for (CourseUnit uc in userUcs) {
          if (!courseExam.examType.contains(
              "Exames ao abrigo de estatutos especiais - Port.Est.Especiais") &&
              courseExam.subject == uc.abbreviation) {
            exams.add(courseExam);
            break;
          }

        }
      }

      // Updates local database according to the information fetched -- Exams
      Tuple2<String, String> userPersistentInfo = await AppSharedPreferences.getPersistentUserInfo();
      if(userPersistentInfo.item1 != "" && userPersistentInfo.item2 != ""){
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
              NetworkRouter.getBaseUrlFromSession(store.state.content['session'])
                  + "mob_hor_geral.estudante?pv_codigo=${store.state.content['session'].studentNumber}"
                  "&pv_semana_ini=$beginWeek&pv_semana_fim=$endWeek",
              {}, store.state.content['session'].cookies));

      // Updates local database according to the information fetched -- Lectures
      Tuple2<String, String> userPersistentInfo = await AppSharedPreferences.getPersistentUserInfo();
      if(userPersistentInfo.item1 != "" && userPersistentInfo.item2 != ""){
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

ThunkAction<AppState> updateSelectedPage(new_page) {
  return (Store<AppState> store) async {
    store.dispatch(new UpdateSelectedPageAction(new_page));
  };
}

ThunkAction<AppState> getUserPrintBalance(Completer<Null> action) {
  return (Store<AppState> store) async {

    String url = NetworkRouter.getBaseUrlFromSession(store.state.content['session']) + "imp4_impressoes.atribs?";

    Map<String, String> query = {"p_codigo": store.state.content['session'].studentNumber};

    String cookies = store.state.content['session'].cookies;

    try {
      var response = await NetworkRouter.getWithCookies(url, query, cookies);
      String printBalance = await getPrintsBalance(response);
      store.dispatch(new SetPrintBalanceAction(printBalance));
    }catch(e){
      print("Failed to get Print Balance");
    }
    action.complete();
  };
}

ThunkAction<AppState> getUserFees(Completer<Null> action) {
  return (Store<AppState> store) async {

    String url = NetworkRouter.getBaseUrlFromSession(store.state.content['session']) + "gpag_ccorrente_geral.conta_corrente_view?";

    Map<String, String> query = {"pct_cod": store.state.content['session'].studentNumber};

    String cookies = store.state.content['session'].cookies;

    try{
      var response = await NetworkRouter.getWithCookies(url, query, cookies);

      String feesBalance = await parseFeesBalance(response);
      store.dispatch(new SetFeesBalanceAction(feesBalance));

      String feesLimit = await parseFeesNextLimit(response);
      store.dispatch(new SetFeesLimitAction(feesLimit));
    }catch(e){
      print("Failed to get Fees info");
    }

    action.complete();
  };
}

ThunkAction<AppState> getUserCoursesState(Completer<Null> action) {
  return (Store<AppState> store) async {

    String url = NetworkRouter.getBaseUrlFromSession(store.state.content['session']) + "fest_geral.cursos_list?";

    Map<String, String> query = {"pv_num_unico": store.state.content['session'].studentNumber};

    String cookies = store.state.content['session'].cookies;

    try{
      var response = await NetworkRouter.getWithCookies(url, query, cookies);

      Map<String,String> coursesStates = await parseCourses(response);

      store.dispatch(new SetCoursesStatesAction(coursesStates));

    }catch(e){
      print("Failed to get Fees info");
    }

    action.complete();
  };
}
