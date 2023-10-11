import 'dart:convert';

import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session.dart';

Future<List<String>> getStudentFaculties(Session session) async {
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
}
