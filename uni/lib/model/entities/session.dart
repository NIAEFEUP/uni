import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/faculties_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';

/// Stores information about a user session.
class Session {
  Session({
    required this.username,
    required this.cookies,
    required this.faculties,
    this.persistentSession = false,
  }) : assert(faculties.isNotEmpty, 'session must have faculties');

  String username;
  String cookies;
  List<String> faculties;
  bool persistentSession;

  /// Creates a new Session instance from an HTTP response.
  /// Returns null if the authentication failed.
  static Future<Session?> fromLogin(
    http.Response response,
    List<String> faculties, {
    required bool persistentSession,
  }) async {
    final responseBody = json.decode(response.body) as Map<String, dynamic>;

    if (!(responseBody['authenticated'] as bool)) {
      return null;
    }

    final session = Session(
      faculties: faculties,
      username: responseBody['codigo'] as String,
      cookies: NetworkRouter.extractCookies(response.headers),
    );

    session.faculties = await getStudentFaculties(session);

    return session;
  }
}
