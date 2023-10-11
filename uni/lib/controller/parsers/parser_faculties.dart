import 'package:html/parser.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

Future<List<String>> getStudentFaculties(Session session) async {
  final registerFaculties = <String>[];

  final pctIdRequest = await NetworkRouter.getWithCookies(
    'https://sigarra.up.pt/up/pt/web_page.inicial',
    {},
    session,
  );
  final pctDocument = parse(pctIdRequest.body);
  final pctId = pctDocument
      .querySelector('a.autenticacao-nome')
      ?.attributes['href']
      ?.toUri()
      .queryParameters['pct_id'];

  final response = await NetworkRouter.getWithCookies(
    'https://sigarra.up.pt/up/pt/vld_entidades_geral.entidade_pagina',
    {'pct_id': '$pctId'},
    session,
  );

  final document = parse(response.body);
  final list = document.querySelectorAll("#conteudoinner>ul a");

  // user is only present in one faculty
  if (list.isEmpty) {
    list.add(document.querySelector("a")!); // the redirection link
  }

  for (final el in list) {
    final uri = el.attributes['href']!.toUri();
    registerFaculties.add(uri.pathSegments[0]);
  }

  return registerFaculties;
}

/*
final Set<String> attendingFaculties = {};

  // it should be done before the calling of this func as it has valuable info
  // for other fetcher
  final response = await NetworkRouter.getWithCookies(
      'https://sigarra.up.pt/feup/pt/mob_fest_geral.perfil',
      {'pv_codigo': session.username},
      session);

  final sessionProfile = json.decode(response.body);

  for (final faculty in sessionProfile['cursos']) {
    attendingFaculties.add(faculty['inst_sigla']);
  }

  return attendingFaculties.toList();
 */

/*

final List<String> registerFaculties = [];

    final http.Response response = await NetworkRouter.getWithCookies(
        'https://sigarra.up.pt/up/pt/vld_entidades_geral.entidade_pagina',
        {'pct_id': '1923456'},
        session);

    final document = parse(response.body);
    final list = document.querySelectorAll("#conteudoinner>ul a");

    // user is only present in one faculty
    if (list.isEmpty) {
      list.add(document.querySelector("a")!); // the redirection link
    }

    for (final el in list) {
      final uri = el.attributes['href']!.toUri();
      registerFaculties.add(uri.pathSegments[0]);
    }

    return registerFaculties;
 */
