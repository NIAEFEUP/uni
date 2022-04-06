import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uni/controller/networking/network_router.dart';

/// Stores information about a user session.
class Session {
  /// Whether or not the user is authenticated.
  bool authenticated;
  bool persistentSession = false;
  List<String> faculties;
  String type;
  String cookies;
  String studentNumber;
  Future loginRequest;

  Session(
      {@required bool this.authenticated,
      List<String> this.faculties,
      this.studentNumber,
      this.type,
      this.cookies}) {}

  // TODO: Is this descriptive enough?
  /// Creates a new instance from an HTTP response to one of the faculties.
  static Session fromLogin(dynamic response, List<String> faculties) {
    final responseBody = json.decode(response.body);
    if (responseBody['authenticated']) {
      return Session(
          authenticated: true,
          faculties: faculties,
          studentNumber: responseBody['codigo'],
          type: responseBody['tipo'],
          cookies: NetworkRouter.extractCookies(response.headers));
    } else {
      return Session(authenticated: false, faculties: faculties);
    }
  }
}
