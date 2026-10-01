import 'dart:async';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uni/http/client/cookie.dart';
import 'package:uni/session/flows/base/session.dart';

Future<List<String>> getStudentFaculties(
  Session session,
  http.Client httpClient,
) async {
  final client = CookieClient(httpClient, cookies: () => session.cookies);

  final response = await client.get(
    Uri.parse(
      'https://sigarra.up.pt/up/pt/vld_entidades_geral.entidade_pagina',
    ).replace(queryParameters: {'pct_codigo': session.username}),
  );

  try {
    final document = parse(response.body);

    final facultiesList = document
        .querySelectorAll('#conteudoinner>ul a')
        .map((e) => e.text);

    if (facultiesList.isEmpty) {
      final anchor = document.querySelector('a');
      if (anchor == null) {
        throw Exception('No anchor found in page to extract single faculty.');
      }
      final singleFaculty = anchor.attributes['href']!;
      final uri = Uri.parse(singleFaculty);
      final faculty = uri.pathSegments[0];
      return [faculty.toLowerCase()];
    }

    final regex = RegExp(r'.*\(([A-Z]+)\)');
    return facultiesList.map((e) {
      final match = regex.firstMatch(e);
      if (match == null) {
        throw Exception('Could not match faculty regex on string: "$e"');
      }
      return match.group(1)!.toLowerCase();
    }).toList();
  } catch (err, st) {
    unawaited(
      Sentry.captureException(
        err,
        stackTrace: st,
        withScope: (s) {
          s.setTag('feature', 'faculties_fetcher');
          s.setTag('action', 'parse_faculties');

          final text = response.body.replaceAll(RegExp(r'\s+'), ' ').trim();
          final snippet = text.length > 300 ? text.substring(0, 300) : text;
          s.setExtra('response_snippet', snippet);
        },
      ),
    );
    throw Exception('Failed to parse faculties from response');
  }
}
