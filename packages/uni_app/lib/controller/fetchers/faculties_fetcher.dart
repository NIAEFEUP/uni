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
    Uri.parse('https://sigarra.up.pt/up/pt/vld_entidades_geral.entidade_pagina')
        .replace(queryParameters: {'pct_codigo': session.username}),
  );

  final document = parse(response.body);

  final facultiesList =
      document.querySelectorAll('#conteudoinner>ul a').map((e) => e.text);

  if (facultiesList.isEmpty) {
    // The user is enrolled in a single faculty,
    // and the selection page is skipped.
    // We can extract the faculty from any anchor.
    final singleFaculty = document.querySelector('a')!.attributes['href']!;
    final uri = Uri.parse(singleFaculty);
    final faculty = uri.pathSegments[0];
    return [faculty.toLowerCase()];
  }

  // We extract the faculties from the list.
  // An example list is (201906166 (FEUP), 201906166 (FCUP)).
  final regex = RegExp(r'.*\(([A-Z]+)\)');
  return facultiesList
      .map((e) => regex.firstMatch(e)!.group(1)!.toLowerCase())
      .toList();
}
