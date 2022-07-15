import 'dart:convert';

import 'package:uni/controller/networking/network_router.dart';

/// Stores information about a user session.
class Session {
  /// Whether or not the user is authenticated.
  bool authenticated;
  bool persistentSession;
  List<String> faculties;
  String type;
  String cookies;
  String studentNumber;
  Future?
      loginRequest; // TODO: accessed directly in Network Router; change the logic

  Session(
      {this.authenticated = false,
      this.studentNumber = '',
      this.type = '',
      this.cookies = '',
      this.faculties = const [''],
      this.persistentSession = false});

  /// Creates a new instance from an HTTP response
  /// to login in one of the faculties.
  static Session fromLogin(dynamic response, List<String> faculties) {
    final responseBody = json.decode(response.body);
    if (responseBody['authenticated']) {
      return Session(
          authenticated: true,
          faculties: faculties,
          studentNumber: responseBody['codigo'],
          type: responseBody['tipo'],
          cookies: NetworkRouter.extractCookies(response.headers),
          persistentSession: false);
    } else {
      return Session(
          authenticated: false,
          faculties: faculties,
          type: '',
          cookies: '',
          studentNumber: '',
          persistentSession: false);
    }
  }
}
