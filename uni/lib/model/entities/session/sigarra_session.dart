import 'dart:convert';

import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/session/session.dart';

/// Stores information about a user session.
class Session extends AbstractSession{
  List<String> faculties;
  String studentNumber;
  Future<bool>? loginRequest; // TODO: accessed directly in Network Router; change the logic

  Session(
      {super.authenticated = false,
      this.studentNumber = '',
      super.cookies = '',
      this.faculties = const [''],
      super.persistentSession = false});

  /// Creates a new instance from an HTTP response
  /// to login in one of the faculties.
  static Session fromLogin(dynamic response, List<String> faculties) {
    final responseBody = json.decode(response.body);
    if (responseBody['authenticated']) {
      return Session(
          authenticated: true,
          faculties: faculties,
          studentNumber: responseBody['codigo'],
          cookies: NetworkRouter.extractCookies(response.headers),
          persistentSession: false);
    } else {
      return Session(
          authenticated: false,
          faculties: faculties,
          cookies: '',
          studentNumber: '',
          persistentSession: false);
    }
  }
}
