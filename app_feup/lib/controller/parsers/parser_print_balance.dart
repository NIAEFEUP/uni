import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';

/// Extracts the print balance of the user's account from an HTTP [response].
Future<String> getPrintBalance(http.Response response) async {
  final document = parse(response.body);

  final String balanceString =
      document.querySelector('.stat-bal').children[1].text;

  return balanceString.replaceAll('\n', ' ');
}

/// Extracts the print balance movements of the user's account
///  from an HTTP [response].
Future<List> getPrintMovements(
    http.Response responseMovements, http.Response responseNewMovements) async {
  final document = parse(responseMovements.body);

  final List rows =
      document.querySelectorAll('table#tab_resultado > tbody > tr');

  final List<Map> movements = rows.map((row) {
    return {
      'datetime': row.children[0].innerHtml.trim().replaceAll('/', '-'),
      'value': row.children[2].innerHtml.replaceAll('&nbsp;', ''),
    };
  }).toList();

  final document2 = parse(responseNewMovements.body);
  final List rows2 = document2.querySelectorAll('tbody > tr');

  final List<Map> newMovements = rows2.map((row) {
    return {
      'datetime': row.children[1].innerHtml.trim().replaceAll('/', '-'),
      'value': '-' + row.children[13].innerHtml.replaceAll('&nbsp;', ''),
    };
  }).toList();

  final List mergedMovements = newMovements + movements;
  mergedMovements.sort((b, a) => a['datetime'].compareTo(b['datetime']));

  return mergedMovements;
}

/// Extracts the print balance movements of the user's account
///  from an HTTP [response].
Future<List> getNewPrintMovements(http.Response response) async {
  final document = parse(response.body);
  final table = document.querySelector('.results tbody');
  final List rows = table.querySelectorAll('.even,.odd');
  final List<Map> movements = rows.map((row) {
    return {
      'datetime': row
          .querySelector('.transactionDateColumnValue')
          .innerHtml
          .replaceAll('\n', ''),
      'value': row
          .querySelector('.amountColumnValue')
          .children[0]
          .innerHtml
          .replaceAll('\n', '')
          .trim()
    };
  }).toList();

  return movements;
}
