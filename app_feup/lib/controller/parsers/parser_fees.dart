import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';

/// Extracts the balance of the user's account from an HTTP [response].
Future<String> parseFeesBalance(http.Response response) async {
  final document = parse(response.body);

  final String balanceString =
      document.querySelector('span#span_saldo_total').text;

  final String balance = balanceString + ' €';

  return balance;
}

/// Extracts the user's payment due date from an HTTP [response].
///
/// If there are no due payments, `Sem data` is returned.
Future<String> parseFeesNextLimit(http.Response response) async {
  final document = parse(response.body);

  final lines = document.querySelectorAll('#tab0 .tabela tr');

  if (lines.length < 2) {
    return 'Sem data';
  }
  final String limit = lines[1].querySelectorAll('.data')[1].text;

  return limit;
}
