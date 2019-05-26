import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';


Future<String> getPrintsBalance(http.Response response) async{

  var document = await parse(response.body);

  String balanceString = document.querySelector('div#conteudoinner > .info').text;

  String balance = balanceString.split(": ")[1];

  return balance;
}