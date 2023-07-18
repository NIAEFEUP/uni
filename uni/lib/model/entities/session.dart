import 'dart:convert';

import 'package:uni/controller/networking/network_router.dart';
import 'package:http/http.dart' as http;

/// Stores information about a user session.
class Session {
  String username;
  String cookies;
  List<String> faculties;
  bool persistentSession;

  Session(
      {required this.username,
      required this.cookies,
      required this.faculties,
      this.persistentSession = false}) {
    assert(faculties.isNotEmpty);
  }

  /// Creates a new Session instance from an HTTP response.
  /// Returns null if the authentication failed.
  static Session? fromLogin(
      http.Response response, List<String> faculties, bool persistentSession) {
    final responseBody = json.decode(response.body);

    if (!responseBody['authenticated']) {
      return null;
    }

    return Session(
        faculties: faculties,
        username: responseBody['codigo'],
        cookies: NetworkRouter.extractCookies(response.headers),
        persistentSession: false);
  }
}
