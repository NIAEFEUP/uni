import 'package:app_feup/controller/parsers/parser-exams.dart';
import 'package:app_feup/controller/parsers/parser-schedule.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../model/AppState.dart';
import 'actions.dart';
import 'package:redux/redux.dart';

ThunkAction<AppState> login(name, password) {
  return (Store<AppState> store) async {
    //do requests, await futures

    String cookies = name + password;

    store.dispatch(new SaveLoginDataAction(cookies));
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

//    List<Lecture> lectures = await scheduleGet("");    TODO Later when login works

    List<Lecture> lectures = new List();
    lectures.add(new Lecture("SOPE", "TE", 1, "14:00", 4, "B303", "JAS"));
    lectures.add(new Lecture("BDAD", "TP", 1, "17:00", 2, "B204", "PMMS"));

    store.dispatch(new SetScheduleAction(lectures));
  };
}