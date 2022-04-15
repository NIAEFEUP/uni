import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:query_params/query_params.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/session.dart';

extension UriString on String {
  /// Converts a [String] to an [Uri].
  Uri toUri() => Uri.parse(this);
}

/// Manages the networking of the app.
class NetworkRouter {
  static http.Client httpClient;

  static const int loginRequestTimeout = 20;

  static Lock loginLock = Lock();

  static Function onReloginFail = () {};

  /// Creates an authenticated [Session] on the given [faculty] with the
  /// given username [user] and password [pass].
  static Future<Session> login(String user, String pass, List<String> faculties,
      bool persistentSession) async {
    final String url =
        NetworkRouter.getBaseUrls(faculties)[0] + 'mob_val_geral.autentica';
    final http.Response response = await http.post(url.toUri(), body: {
      'pv_login': user,
      'pv_password': pass
    }).timeout(const Duration(seconds: loginRequestTimeout));
    if (response.statusCode == 200) {
      final Session session = Session.fromLogin(response, faculties);
      session.persistentSession = persistentSession;
      Logger().i('Login successful');
      return session;
    } else {
      Logger().e('Login failed');
      return Session(authenticated: false, faculties: faculties);
    }
  }

  /// Determines if a re-login with the [session] is possible.
  static Future<bool> relogin(Session session) {
    return loginLock.synchronized(() async {
      if (!session.persistentSession) {
        return false;
      }

      if (session.loginRequest != null) {
        return session.loginRequest;
      } else {
        return session.loginRequest = loginFromSession(session).then((_) {
          session.loginRequest = null;
        });
      }
    });
  }

  /// Re-authenticates the user [session].
  static Future<bool> loginFromSession(Session session) async {
    Logger().i('Trying to login...');
    final String url = NetworkRouter.getBaseUrls(session.faculties)[0] +
        'mob_val_geral.autentica';
    final http.Response response = await http.post(url.toUri(), body: {
      'pv_login': session.studentNumber,
      'pv_password': await AppSharedPreferences.getUserPassword(),
    }).timeout(const Duration(seconds: loginRequestTimeout));
    final responseBody = json.decode(response.body);
    if (response.statusCode == 200 && responseBody['authenticated']) {
      session.authenticated = true;
      session.studentNumber = responseBody['codigo'];
      session.type = responseBody['tipo'];
      session.cookies = NetworkRouter.extractCookies(response.headers);
      Logger().i('Re-login successful');
      return true;
    } else {
      Logger().e('Re-login failed');
      return false;
    }
  }

  /// Extracts the cookies present in [headers].
  static String extractCookies(dynamic headers) {
    final List<String> cookieList = <String>[];
    final String cookies = headers['set-cookie'];
    if (cookies != null) {
      final List<String> rawCookies = cookies.split(',');
      for (var c in rawCookies) {
        cookieList.add(Cookie.fromSetCookieValue(c).toString());
      }
    }
    return cookieList.join(';');
  }

  /// Makes an authenticated GET request with the given [session] to the
  /// resource located at [url] with the given [query] parameters.
  static Future<http.Response> getWithCookies(
      String baseUrl, Map<String, String> query, Session session) async {
    final loginSuccessful = await session.loginRequest;
    if (loginSuccessful is bool && !loginSuccessful) {
      return Future.error('Login failed');
    }

    final URLQueryParams params = URLQueryParams();
    query.forEach((key, value) {
      params.append(key, value);
    });

    if (!baseUrl.contains('?')) {
      baseUrl += '?';
    }
    final url = baseUrl + params.toString();

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] = session.cookies;
    final http.Response response = await (httpClient != null
        ? httpClient.get(url.toUri(), headers: headers)
        : http.get(url.toUri(), headers: headers));
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 403) {
      // HTTP403 - Forbidden
      final bool success = await relogin(session);
      if (success) {
        headers['cookie'] = session.cookies;
        return http.get(url.toUri(), headers: headers);
      } else {
        onReloginFail();
        Logger().e('Login failed');
        return Future.error('Login failed');
      }
    } else {
      return Future.error('HTTP Error ${response.statusCode}');
    }
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
