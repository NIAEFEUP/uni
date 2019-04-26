import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';

Future<String> parseFeesBalance(http.Response response) async{

  var document = await parse(response.body);

  String balanceString = document.querySelector('span#span_saldo_total').text;

  String balance = balanceString + " €";

  return balance;
}

Future<String> parseFeesNextLimit(http.Response response) async{

  var document = await parse(response.body);

  var lines = document.querySelectorAll('#tab0 .tabela tr');

  if(lines.length < 2){
    return 'Sem data';
  }
  String limit = lines[1].querySelectorAll('.data')[1].text;

  return limit;
}