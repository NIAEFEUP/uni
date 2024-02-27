import 'package:html/parser.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

Future<List<String>> getStudentFaculties(Session session) async {
  final registerFaculties = <String>[];

  final query = {'pct_codigo': session.username};
  const baseUrl =
      'https://sigarra.up.pt/up/pt/vld_entidades_geral.entidade_pagina';

  final pctRequest =
      await NetworkRouter.getWithCookies(baseUrl, query, session);

  final pctDocument = parse(pctRequest.body);

  final list =
      pctDocument.querySelectorAll('#conteudoinner>ul a').map((e) => e.text);

  //user is enrolled in only one faculty
  if (list.isEmpty) {
    final singleFaculty = pctDocument.querySelector('a')!.attributes['href'];
    final regex2 = RegExp(r'.*\/([a-z]+)\/.*');
    final faculty = regex2.firstMatch(singleFaculty!)?.group(1)?.toUpperCase();
    registerFaculties.add(faculty!);
  } else {
    final regex = RegExp(r'.*\(([A-Z]+)\)');
    for (final element in list) {
      registerFaculties.add(regex.firstMatch(element)!.group(1)!);
    }
  }
  return registerFaculties;
}
