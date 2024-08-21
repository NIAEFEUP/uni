import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uni/session/credentials/session.dart';
import 'package:uni/session/session.dart';
import 'package:uni/utils/constants.dart';
import 'package:uni/view/navigation_service.dart';

extension UriString on String {
  /// Converts a [String] to an [Uri].
  Uri toUri() => Uri.parse(this);
}

/// Manages the networking of the app.
class NetworkRouter {
  /// The HTTP client used for all requests.
  /// Can be set to null to use the default client.
  /// This is useful for testing.
  static http.Client? httpClient;

  /// The timeout for Sigarra login requests.
  static const Duration _requestTimeout = Duration(seconds: 30);

  /// Re-authenticates the user via the Sigarra API
  /// using data stored in [session],
  /// returning an updated Session if successful.
  static Future<Session?> reLoginFromSession(Session session) async {
    final request = session.createRefreshRequest();
    try {
      return request.perform();
    } catch (err, st) {
      Logger().e(err, stackTrace: st);
      return null;
    }
  }

  static Future<Session?> login(String username, String password) async {
    final url = '${getBaseUrl('feup')}mob_val_geral.autentica';
    final response = await http.post(
      url.toUri(),
      body: {'pv_login': username, 'pv_password': password},
    ).timeout(_requestTimeout);

    if (response.statusCode != 200) {
      Logger().e('Login failed with status code ${response.statusCode}');
      return null;
    }

    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    if (!(responseBody['authenticated'] as bool)) {
      Logger().e('Login failed: user not authenticated');
      return null;
    }

    final realUsername = responseBody['codigo'] as String;
    final session = CredentialsSession(
      username: realUsername,
      cookies: extractCookies(response),
      faculties: faculties,
      password: password,
    );

    Logger().i('Login successful');
    _lastLoginTime = DateTime.now();
    _cachedSession = session;

    return session;
  }

  /// Returns the response body of the login in Sigarra
  /// given username [user] and password [pass].
  static Future<String> loginInSigarra(
    String user,
    String pass,
    List<String> faculties,
  ) async {
    final url =
        '${NetworkRouter.getBaseUrls(faculties)[0]}vld_validacao.validacao';
    final response = await http.post(
      url.toUri(),
      body: {'p_user': user, 'p_pass': pass},
    ).timeout(_requestTimeout);
    return response.body;
  }

  /// Returns the base url of the user's faculties.
  static List<String> getBaseUrls(List<String> faculties) {
    return faculties.map(getBaseUrl).toList();
  }

  /// Returns the base url of the user's faculty.
  static String getBaseUrl(String faculty) {
    return 'https://sigarra.up.pt/$faculty/pt/';
  }

  /// Returns the base url from the user's previous session.
  static List<String> getBaseUrlsFromSession(Session session) {
    return NetworkRouter.getBaseUrls(session.faculties);
  }
}
