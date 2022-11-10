import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:uni/model/entities/print_release.dart';

/// Extracts the print balance of the user's account from an HTTP [response].
Future<String> getPrintsBalance(http.Response response) async {
  final document = parse(response.body);

  final String? balanceString =
      document.querySelector('div#conteudoinner > .info')?.text;

  final String? balance = balanceString?.split(': ')[1];

  return balance ?? '';
}

/// Extracts the print balance of the user's account from an HTTP [response].
Future<String> getPrintsBalanceFromPrintsUP(http.Response response) async {
  final document = parse(response.body);

  final String? balance = document.querySelector('.stat-bal > .val')?.text;

  return balance ?? '?';
}

/// Extracts the pending releases of the user's account from an HTTP [response].
Future<List> getPendingReleases(http.Response response) async {
  final document = parse(response.body);

  final List rows = document.querySelectorAll('#jobs-table > tbody > tr');
  final List<PrintRelease> releases = rows.map((row) {
    final String filename =
            row.querySelector('.documentColumnValue > span')?.text,
        datetime = row.querySelector('.dateColumnValue')?.text,
        cost = row.querySelector('.costColumnValue > div')?.text,
        pages = row.querySelector('.pagesColumnValue > div')?.text,
        printer = row.querySelector('.printerColumnValue > span')?.text,
        cancelUrl = row.querySelector('.actionColumnValue > a')?.href;

    return PrintRelease.fromParser(filename, datetime, cost, pages, printer, cancelUrl);
  }).toList();

  return releases;
}
