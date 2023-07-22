import 'dart:convert';

import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';

/// Stores information about a user session.
class Session {
  // TODO: accessed directly in Network Router; change the logic

  Session({
    this.authenticated = false,
    this.studentNumber = '',
    this.type = '',
    this.cookies = '',
    this.faculties = const [''],
    this.persistentSession = false,
  });

  /// Creates a new instance from an HTTP response
  /// to login in one of the faculties.
  factory Session.fromLogin(Response response, List<String> faculties) {
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    if (responseBody['authenticated'] as bool) {
      return Session(
        authenticated: true,
        faculties: faculties,
        studentNumber: responseBody['codigo'] as String,
        type: responseBody['tipo'] as String,
        cookies: NetworkRouter.extractCookies(response.headers),
      );
    } else {
      return Session(
        faculties: faculties,
      );
    }
  }

  /// Whether or not the user is authenticated.
  bool authenticated;
  bool persistentSession;
  List<String> faculties;
  String type;
  String cookies;
  String studentNumber;
  Future<bool>? loginRequest;
}
