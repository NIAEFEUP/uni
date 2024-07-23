import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';

/// Stores information about a user session.
class Session {
  Session({
    required this.username,
    required this.cookies,
    required this.faculties,
    this.persistentSession = false,
    this.federatedSession = false,
  }) : assert(faculties.isNotEmpty, 'session must have faculties');

  String username;
  List<Cookie> cookies;
  List<String> faculties;
  bool persistentSession;
  bool federatedSession;

  /// Creates a new Session instance from an HTTP response.
  /// Returns null if the authentication failed.
  static Session? fromLogin(
    http.Response response,
    List<String> faculties, {
    required bool persistentSession,
  }) {
    final responseBody = json.decode(response.body) as Map<String, dynamic>;

    if (!(responseBody['authenticated'] as bool)) {
      return null;
    }

    return Session(
      faculties: faculties,
      username: responseBody['codigo'] as String,
      cookies: NetworkRouter.extractCookies(response.headers),
    );
  }
}
