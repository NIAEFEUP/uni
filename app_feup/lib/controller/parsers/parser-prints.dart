import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:redux/redux.dart';


Future<String> getPrintsBalance(String link, Store<AppState> store) async{
  Map<String, String> query = {"p_codigo": store.state.content['session']['studentNumber']};

  String cookies = store.state.content['session']['cookies'];

  var response = await NetworkRouter.getWithCookies(link, query, cookies);

  var document = parse(response.body);

  //print(document);
  
  //TODO: CONTINUAR AQUI 

  return "21";
}