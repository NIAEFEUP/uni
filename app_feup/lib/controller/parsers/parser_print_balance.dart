import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';

/// Extracts the print balance of the user's account from an HTTP [response].
Future<String> getPrintsBalance(http.Response response) async {
  final document = parse(response.body);

  final String balanceString =
      document.querySelector('div#conteudoinner > .info').text;

  final String balance = balanceString.split(': ')[1];

  return balance;
}

/// Extracts the print balance movements of the user's account
///  from an HTTP [response].
Future<List> getPrintMovements(http.Response response) async {
  final document = parse(response.body);

  final List<Map> movements = [];

  final List rows =
      document.querySelectorAll('table#tab_resultado > tbody > tr');

  for (var row in rows) {
    movements.add({
      'date': row.children[0].innerHtml
          .trim()
          .split(' ')[0]
          .split('/')
          .reversed
          .join('/'),
      'hour': row.children[0].innerHtml.trim().split(' ')[1],
      'value': row.children[2].innerHtml.replaceAll('&nbsp;', ''),
    });
  }
  return movements;
}
