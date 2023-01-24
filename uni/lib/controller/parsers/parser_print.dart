import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:uni/model/entities/print_job.dart';

/// Extracts the print balance of the user's account from an HTTP [response].
Future<String> getPrintsBalance(http.Response response) async {
  final document = parse(response.body);
  final String? balance = document.querySelector('.stat-bal > .val')?.text;
  return balance ?? '?';
}

/// Extracts the pending releases of the user's account from an HTTP [response].
Future<List<PrintJob>> getPendingReleases(http.Response response) async {
  final document = parse(response.body);

  final List rows = document.querySelectorAll('#jobs-table > tbody > tr');
  rows.removeAt(0);

  final List<PrintJob> jobs = rows.map((row) {
    final String filename =
            row.querySelector('.documentColumnValue > span')?.text ?? '',
        datetime = row.querySelector('.dateColumnValue > span')?.text ?? '',
        cost = row.querySelector('.costColumnValue > div')?.text ?? '',
        pages = row.querySelector('.pagesColumnValue > div')?.text ?? '',
        printer = row.querySelector('.printerColumnValue > span')?.text ?? '',
        cancelUrl =
            row.querySelector('.actionColumnValue > a')?.attributes['href'] ??
                '';

    return PrintJob.fromParser(
        filename, datetime, cost, pages, printer, cancelUrl);
  }).toList();

  return jobs;
}
