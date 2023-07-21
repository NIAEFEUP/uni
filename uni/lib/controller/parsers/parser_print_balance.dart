import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

/// Extracts the print balance of the user's account from an HTTP [response].
Future<String> getPrintsBalance(http.Response response) async {
  final document = parse(response.body);

  final balanceString =
      document.querySelector('div#conteudoinner > .info')?.text;

  final balance = balanceString?.split(': ')[1];

  return balance ?? '';
}
