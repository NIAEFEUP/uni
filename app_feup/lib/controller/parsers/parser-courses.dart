import 'package:html/parser.dart' show parse;
import 'dart:async';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:redux/redux.dart';
import 'dart:collection';

Future<Map<String, String>> getCourseState(String link, Store<AppState> store) async{
  Map<String, String> query = {"pv_num_unico": store.state.content['session'].studentNumber};

  String cookies = store.state.content['session'].cookies;

  var response = await NetworkRouter.getWithCookies(link, query, cookies);

  var document = await parse(response.body);

  Map<String, String> coursesStates = new HashMap();
  
  var courses = document.querySelectorAll('.estudantes-caixa-lista-cursos > div');

  for(int i = 0; i < courses.length; i++){
    var div = courses[i];
    var course = div.querySelector('.estudante-lista-curso-nome > a').text;
    var state = div.querySelectorAll('.formulario td')[3].text;

    coursesStates.putIfAbsent(course, () => state);
  }

  return coursesStates;
}