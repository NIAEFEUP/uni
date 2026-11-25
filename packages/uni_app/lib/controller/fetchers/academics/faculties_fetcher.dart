import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:uni/http/client/cookie.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/utils/constants.dart';

Future<List<String>> getStudentFaculties(
  Session session,
  http.Client httpClient,
) async {
  final client = CookieClient(httpClient, cookies: () => session.cookies);

  final studentNumber = session.username.replaceFirst(
    RegExp('^up', caseSensitive: false),
    '',
  );

  final response = await client.get(
    Uri.parse(
      'https://sigarra.up.pt/up/pt/vld_entidades_geral.entidade_pagina',
    ).replace(queryParameters: {'pct_codigo': studentNumber}),
  );

  final document = parse(response.body);

  final facultiesList = document
      .querySelectorAll('#conteudoinner>ul a')
      .map((e) => e.text);

  if (facultiesList.isEmpty) {
    // The user is enrolled in a single faculty,
    // and the selection page is skipped.
    // We can extract the faculty from any anchor or meta-refresh tag.
    final anchor = document.querySelector('a[href]');
    if (anchor != null) {
      final href = anchor.attributes['href'];
      if (href != null) {
        final uri = Uri.tryParse(href);
        if (uri != null && uri.pathSegments.isNotEmpty) {
          final faculty = uri.pathSegments[0].toLowerCase();
          if (faculties.contains(faculty)) {
            return [faculty];
          }
        }
      }
    }

    final refreshMeta = document.querySelector('meta[http-equiv="Refresh" i]');
    if (refreshMeta != null) {
      final content = refreshMeta.attributes['content'];
      if (content != null) {
        final match =
            RegExp('url=(.*)', caseSensitive: false).firstMatch(content);
        if (match != null) {
          final uri = Uri.tryParse(match.group(1)!.trim());
          if (uri != null && uri.pathSegments.isNotEmpty) {
            final faculty = uri.pathSegments[0].toLowerCase();
            if (faculties.contains(faculty)) {
              return [faculty];
            }
          }
        }
      }
    }

    Logger().w('Failed to find student faculties in HTML response');
    return [];
  }

  // We extract the faculties from the list.
  // An example list is (201906166 (FEUP), 201906166 (FCUP)).
  final regex = RegExp(r'.*\(([A-Z]+)\)');
  return facultiesList
      .map((e) => regex.firstMatch(e)?.group(1)?.toLowerCase())
      .whereType<String>()
      .where((faculty) => faculties.contains(faculty))
      .toList();
}
