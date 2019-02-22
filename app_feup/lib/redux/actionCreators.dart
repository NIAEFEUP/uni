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
      } else {
        store.dispatch(new SetLoginStatusAction(LoginStatus.FAILED));
      }
    } catch (e) {
      store.dispatch(new SetLoginStatusAction(LoginStatus.FAILED));
    }
  };
}

ThunkAction<AppState> fetchUserInfo() {
  return (Store<AppState> store) async {
    try {
      final profile = NetworkRouter.getProfile(store.state.content['session']).then((res) => store.dispatch(new SaveProfileAction(res)));
      final ucs = NetworkRouter.getUcs(store.state.content['session']).then((res) => store.dispatch(new SaveUcsAction(res)));
      await Future.wait([profile, ucs]);
      store.dispatch(new SetLoginStatusAction(LoginStatus.SUCCESSFUL));
      print(store.state.content);
    } catch (e) {
      print(e);
    }
  };
}

ThunkAction<AppState> getUserExams() {
  return (Store<AppState> store) async {
    //need to get student course here

    List<Exam> exams = await examsGet("https://sigarra.up.pt/feup/pt/exa_geral.mapa_de_exames?p_curso_id=742");

    store.dispatch(new SetExamsAction(exams));
  };
}

ThunkAction<AppState> getUserSchedule() {
  return (Store<AppState> store) async {
    //need to get student schedule here

    //TODO when login is done, uncomment and replace pv_fest_id with user's and pv_ano_letivo with current school year
    // List<Lecture> lectures = await scheduleGet(await NetworkRouter.getWithCookies("https://sigarra.up.pt/feup/pt/hor_geral.estudantes_view?pv_fest_id=1000108&pv_ano_lectivo=2018&pv_periodos=1", {}, store.state.content['session']['cookies']));

    List<Lecture> lectures = new List();

    lectures.add(new Lecture("SOPE", "TP", 0, "14:00", 4, "B310", "FHFC"));
    lectures.add(new Lecture("BDAD", "TE", 0, "17:00", 2, "B001", "CTL"));
    lectures.add(new Lecture("BDAD", "TP", 0, "18:00", 4, "B301", "JPMM"));

    lectures.add(new Lecture("LPOO", "TE", 1, "16:00", 4, "B022", "AOR"));

    lectures.add(new Lecture("CAL", "TE", 2, "08:30", 2, "B001", "RR"));
    lectures.add(new Lecture("BDAD", "TE", 2, "09:30", 2, "B001", "CTL"));
    lectures.add(new Lecture("SOPE", "TE", 2, "10:30", 2, "B001", "JAS"));
    lectures.add(new Lecture("CGRA", "TP", 2, "11:30", 4, "B310", "AFCC"));

    lectures.add(new Lecture("LPOO", "TP", 3, "14:00", 6, "B203", "FFC"));
    lectures.add(new Lecture("SOPE", "TE", 3, "17:00", 2, "B001", "JAS"));

    lectures.add(new Lecture("CGRA", "TE", 4, "14:00", 4, "B003", "AAS"));
    lectures.add(new Lecture("CAL", "TE", 4, "16:00", 2, "B003", "RR"));
    lectures.add(new Lecture("CAL", "TP", 4, "17:00", 4, "B107", "LFT"));

    store.dispatch(new SetScheduleAction(lectures));
  };
}

ThunkAction<AppState> updateSelectedPage(new_page) {
  return (Store<AppState> store) async {
    store.dispatch(new UpdateSelectedPageAction(new_page));
  };
}