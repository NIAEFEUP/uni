import 'dart:io';

import 'package:uni/controller/session/request.dart';

abstract class Session {
  Session({
    required this.username,
    required this.cookies,
    required this.faculties,
  }) : assert(faculties.isNotEmpty, 'session must have faculties');

  final String username;
  final List<String> faculties;
  final List<Cookie> cookies; // TODO(limwa): use a CookieJar

  SessionRequest createRefreshRequest();
}
