import 'dart:async';
import 'package:app_feup/controller/loadinfo.dart';
import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../model/AppState.dart';
import 'actions.dart';
import 'package:redux/redux.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/LoginPageModel.dart';

ThunkAction<AppState> login(username, password, faculty, persistentSession) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new SetLoginStatusAction(LoginStatus.BUSY));
      final Map<String, dynamic> session = await NetworkRouter.login(username, password, faculty, persistentSession);
      print(session);
      store.dispatch(new SaveLoginDataAction(session));
      if (session['authenticated']){
        loadUserInfoToState(store);
        store.dispatch(new SetLoginStatusAction(LoginStatus.SUCCESSFUL));
      } else {
        store.dispatch(new SetLoginStatusAction(LoginStatus.FAILED));
      }
    } catch (e) {
      store.dispatch(new SetLoginStatusAction(LoginStatus.FAILED));
    }
  };
}

ThunkAction<AppState> fetchProfile() {
  return (Store<AppState> store) async {
    try {
      final Map<String, dynamic> profile = await NetworkRouter.getProfile(store.state.content['session']);
      print(profile); //just to supress warning for now
    } catch (e) {
      print(e);
    }
  };
}

ThunkAction<AppState> getUserExams(Completer<Null> action) {
  return (Store<AppState> store) async {
    //need to get student course here

    List<Exam> exams = await examsGet("https://sigarra.up.pt/feup/pt/exa_geral.mapa_de_exames?p_curso_id=742");

    action.complete();
    store.dispatch(new SetExamsAction(exams));
  };
}

ThunkAction<AppState> getUserSchedule(Completer<Null> action) {
  return (Store<AppState> store) async {
    //need to get student schedule here

    var date = DateTime.now();
    String beginWeek = date.year.toString().padLeft(4, '0') + date.month.toString().padLeft(2, '0') + date.day.toString().padLeft(2, '0');
    date = date.add(new Duration(days: 6));
    String endWeek = date.year.toString().padLeft(4, '0') + date.month.toString().padLeft(2, '0') + date.day.toString().padLeft(2, '0');

    List<Lecture> lectures = await scheduleGet(await NetworkRouter.getWithCookies("https://sigarra.up.pt/${store.state.content['session']['faculty']}/pt/mob_hor_geral.estudante?pv_codigo=${store.state.content['session']['studentNumber']}&pv_semana_ini=$beginWeek&pv_semana_fim=$endWeek", {}, store.state.content['session']['cookies']));

    action.complete();

    store.dispatch(new SetScheduleAction(lectures));
  };
}

ThunkAction<AppState> updateSelectedPage(new_page) {
  return (Store<AppState> store) async {
    store.dispatch(new UpdateSelectedPageAction(new_page));
  };
}