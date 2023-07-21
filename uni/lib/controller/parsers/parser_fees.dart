import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

/// Extracts the balance of the user's account from an HTTP [response].
Future<String> parseFeesBalance(http.Response response) async {
  final document = parse(response.body);

  final balanceString = document.querySelector('span#span_saldo_total')?.text;

  final balance = '$balanceString €';

  return balance;
}

/// Extracts the user's payment due date from an HTTP [response].
///
/// If there are no due payments, `Sem data` is returned.
Future<DateTime?> parseFeesNextLimit(http.Response response) async {
  final document = parse(response.body);

  final lines = document.querySelectorAll('#tab0 .tabela tr');

  if (lines.length < 2) {
    return null;
  }
  final limit = lines[1].querySelectorAll('.data')[1].text;

  //it's completly fine to throw an exeception if it fails, in this case,
  //since probably sigarra is returning something we don't except
  return DateTime.parse(limit);
}
