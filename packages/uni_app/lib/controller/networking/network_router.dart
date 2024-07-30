import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uni/controller/session/credentials/session.dart';
import 'package:uni/controller/session/session.dart';
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

  /// The mutual exclusion primitive for login requests.
  static final Lock _loginLock = Lock();

  /// The last time the user was logged in.
  /// Used to avoid repeated concurrent login requests.
  static DateTime? _lastLoginTime;

  /// Cached session for the current user.
  /// Returned on repeated concurrent login requests.
  static Session? _cachedSession;

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

  /// Extracts the cookies present in [response].
  static List<Cookie> extractCookies(http.Response response) {
    final setCookieHeaders =
        response.headersSplitValues[HttpHeaders.setCookieHeader];
    if (setCookieHeaders == null) {
      return [];
    }

    final cookies = <Cookie>[];
    for (final value in setCookieHeaders) {
      cookies.add(Cookie.fromSetCookieValue(value));
    }

    return cookies;
  }

  /// Makes an authenticated GET request with the given [session] to the
  /// resource located at [baseUrl] with the given [query] parameters.
  /// If the request fails with a 403 status code, the user is re-authenticated
  /// and the session is updated.
  static Future<http.Response> getWithCookies(
    String baseUrl,
    Map<String, String> query,
    Session session, {
    Duration timeout = _requestTimeout,
  }) async {
    var url = baseUrl;
    if (!url.contains('?')) {
      url += '?';
    }
    query.forEach((key, value) {
      url += '$key=$value&';
    });
    if (query.isNotEmpty) {
      url = url.substring(0, url.length - 1);
    }

    final headers = <String, String>{};
    headers['cookie'] = session.cookies.join('; ');

    final response = await (httpClient != null
            ? httpClient!.get(url.toUri(), headers: headers).timeout(timeout)
            : http.get(url.toUri(), headers: headers))
        .timeout(timeout);

    if (response.statusCode == 200) {
      return response;
    }

    final forbidden = response.statusCode == 403;
    if (forbidden) {
      final userIsLoggedIn =
          _cachedSession != null && await userLoggedIn(session);
      if (!userIsLoggedIn) {
        Logger()
            .d('User is not logged in; performing re-login from saved data');

        final newSession = await reLoginFromSession(session);

        if (newSession == null) {
          NavigationService.logoutAndPopHistory();
          return Future.error(
            'Re-login failed; user might have changed password',
          );
        }

        session
          ..username = newSession.username // (thePeras): Why is this necessary?
          ..cookies =
              newSession.cookies; // TODO(limwa): because it is very bad code xD

        headers['cookie'] = session.cookies.join('; ');
        return http.get(url.toUri(), headers: headers).timeout(timeout);
      } else {
        // If the user is logged in but still got a 403, they are
        // forbidden to access the resource or the login was invalid
        // at the time of the request,
        // but other thread re-authenticated.
        // Since we do not know which one is the case, we try again.
        headers['cookie'] = session.cookies.join('; ');
        final response =
            await http.get(url.toUri(), headers: headers).timeout(timeout);
        return response.statusCode == 200
            ? Future.value(response)
            : Future.error('HTTP Error: ${response.statusCode}');
      }
    }

    return Future.error('HTTP Error: ${response.statusCode}');
  }

  /// Check if the user is still logged in,
  /// performing a health check on the user's personal page.
  static Future<bool> userLoggedIn(Session session) async {
    Logger().d('Checking if user is still logged in');

    final url = '${getBaseUrl(session.faculties[0])}'
        'fest_geral.cursos_list?pv_num_unico=${session.username}';
    final headers = <String, String>{};
    headers['cookie'] = session.cookies.join('; ');

    final response = await (httpClient != null
        ? httpClient!.get(url.toUri(), headers: headers)
        : http.get(url.toUri(), headers: headers));

    return response.statusCode == 200;
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

  /// Makes an HTTP request to terminate the session in Sigarra.
  static Future<Response> killSigarraAuthentication(
      List<String> faculties) async {
    final url = '${NetworkRouter.getBaseUrl(faculties[0])}vld_validacao.sair';
    final response = await http.get(url.toUri()).timeout(_requestTimeout);

    if (response.statusCode == 200) {
      Logger().i('Logout Successful');
    } else {
      Logger().i('Logout Failed');
    }

    return response;
  }
}
