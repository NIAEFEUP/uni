import 'package:app_feup/model/entities/Session.dart';
import 'package:html/parser.dart' show parse;
import 'dart:async';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:redux/redux.dart';


Future<String> getFeesBalance(String link, Store<AppState> store) async{
  Map<String, String> query = {"pct_cod": store.state.content['session'].studentNumber};

  Session session = store.state.content['session'];

  var response = await NetworkRouter.getWithCookies(link, query, session);

  var document = await parse(response.body);

  String balanceString = document.querySelector('span#span_saldo_total').text;

  String balance = balanceString + " €";

  return balance;
}