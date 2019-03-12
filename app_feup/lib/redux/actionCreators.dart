import 'dart:async';
import 'package:app_feup/controller/loadinfo.dart';
import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:app_feup/controller/parsers/parser-prints.dart';
import 'package:app_feup/controller/parsers/parser-fees.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../model/AppState.dart';
import 'actions.dart';
import 'package:redux/redux.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';

ThunkAction<AppState> login(username, password, faculty, persistentSession) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new SetLoginStatusAction(RequestStatus.BUSY));
      final Map<String, dynamic> session = await NetworkRouter.login(username, password, faculty, persistentSession);
      print(session);
      store.dispatch(new SaveLoginDataAction(session));
      if (session['authenticated']){
        loadUserInfoToState(store);
        store.dispatch(new SetLoginStatusAction(RequestStatus.SUCCESSFUL));
      } else {
        store.dispatch(new SetLoginStatusAction(RequestStatus.FAILED));
      }
    } catch (e) {
      store.dispatch(new SetLoginStatusAction(RequestStatus.FAILED));
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
    try {
    //need to get student course here
    store.dispatch(new SetExamsStatusAction(RequestStatus.BUSY));
    List<Exam> exams = await examsGet("https://sigarra.up.pt/${store.state.content['session']['faculty']}/pt/exa_geral.mapa_de_exames?p_curso_id=742");
    action.complete();
    store.dispatch(new SetExamsStatusAction(RequestStatus.SUCCESSFUL));
    store.dispatch(new SetExamsAction(exams));
    } catch (e) {
      store.dispatch(new SetExamsStatusAction(RequestStatus.FAILED));
    }
  };
}

ThunkAction<AppState> getUserSchedule(Completer<Null> action) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(new SetScheduleStatusAction(RequestStatus.BUSY));
      var date = DateTime.now();
      String beginWeek = date.year.toString().padLeft(4, '0') + date.month.toString().padLeft(2, '0') + date.day.toString().padLeft(2, '0');
      date = date.add(new Duration(days: 6));
      String endWeek = date.year.toString().padLeft(4, '0') + date.month.toString().padLeft(2, '0') + date.day.toString().padLeft(2, '0');
      
      List<Lecture> lectures = await scheduleGet(await NetworkRouter.getWithCookies("https://sigarra.up.pt/${store.state.content['session']['faculty']}/pt/mob_hor_geral.estudante?pv_codigo=${store.state.content['session']['studentNumber']}&pv_semana_ini=$beginWeek&pv_semana_fim=$endWeek", {}, store.state.content['session']['cookies']));
      action.complete();
      store.dispatch(new SetScheduleStatusAction(RequestStatus.SUCCESSFUL));
      store.dispatch(new SetScheduleAction(lectures));
    } catch (e) {
      store.dispatch(new SetScheduleStatusAction(RequestStatus.FAILED));
    }
  };
}

ThunkAction<AppState> updateSelectedPage(new_page) {
  return (Store<AppState> store) async {
    store.dispatch(new UpdateSelectedPageAction(new_page));
  };
}

ThunkAction<AppState> getUserPrintBalance(Completer<Null> action) {
  return (Store<AppState> store) async {

      String url = "https://sigarra.up.pt/${store.state.content['session']['faculty']}/pt/imp4_impressoes.atribs?";

    String printBalance = await getPrintsBalance(url, store);
    action.complete();
    store.dispatch(new SetPrintBalanceAction(printBalance));
  };
}

ThunkAction<AppState> getUserFeesBalance(Completer<Null> action) {
  return (Store<AppState> store) async {

    String url = "https://sigarra.up.pt/${store.state.content['session']['faculty']}/pt/gpag_ccorrente_geral.conta_corrente_view?";

    String feesBalance = await getFeesBalance(url, store);
    action.complete();
    store.dispatch(new SetFeesBalanceAction(feesBalance));
  };
}
