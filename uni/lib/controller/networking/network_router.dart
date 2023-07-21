import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/view/navigation_service.dart';

extension UriString on String {
  /// Converts a [String] to an [Uri].
  Uri toUri() => Uri.parse(this);
}

/// Manages the networking of the app.
class NetworkRouter {
  static http.Client? httpClient;
  static const int loginRequestTimeout = 20;
  static Lock loginLock = Lock();

  /// Creates an authenticated [Session] on the given [faculty] with the
  /// given username [user] and password [pass].
  static Future<Session> login(
    String user,
    String pass,
    List<String> faculties, {
    required bool persistentSession,
  }) async {
    final url =
        '${NetworkRouter.getBaseUrls(faculties)[0]}mob_val_geral.autentica';
    final response = await http.post(
      url.toUri(),
      body: {'pv_login': user, 'pv_password': pass},
    ).timeout(const Duration(seconds: loginRequestTimeout));
    if (response.statusCode == 200) {
      final session = Session.fromLogin(response, faculties)
        ..persistentSession = persistentSession;
      Logger().i('Login successful');
      return session;
    } else {
      Logger().e('Login failed: ${response.body}');

      return Session(
        faculties: faculties,
      );
    }
  }

  /// Determines if a re-login with the [session] is possible.
  static Future<bool> reLogin(Session session) {
    return loginLock.synchronized(() async {
      if (!session.persistentSession) {
        return false;
      }

      if (session.loginRequest != null) {
        return session.loginRequest!;
      } else {
        return session.loginRequest = loginFromSession(session).then((_) {
          session.loginRequest = null;
          return true;
        });
      }
    });
  }

  /// Re-authenticates the user [session].
  static Future<bool> loginFromSession(Session session) async {
    Logger().i('Trying to login...');
    final url =
        '${NetworkRouter.getBaseUrls(session.faculties)[0]}mob_val_geral.autentica';
    final response = await http.post(
      url.toUri(),
      body: {
        'pv_login': session.studentNumber,
        'pv_password': await AppSharedPreferences.getUserPassword(),
      },
    ).timeout(const Duration(seconds: loginRequestTimeout));
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 && responseBody['authenticated'] as bool) {
      session
        ..authenticated = true
        ..studentNumber = responseBody['codigo'] as String
        ..type = responseBody['tipo'] as String
        ..cookies = NetworkRouter.extractCookies(response.headers);
      Logger().i('Re-login successful');
      return true;
    } else {
      Logger().e('Re-login failed');
      return false;
    }
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
    ).timeout(const Duration(seconds: loginRequestTimeout));

    return response.body;
  }

  /// Extracts the cookies present in [headers].
  static String extractCookies(Map<String, String> headers) {
    final cookieList = <String>[];
    final cookies = headers['set-cookie'];
    if (cookies != '') {
      final rawCookies = cookies?.split(',');
      for (final c in rawCookies ?? []) {
        cookieList.add(Cookie.fromSetCookieValue(c as String).toString());
      }
    }
    return cookieList.join(';');
  }

  /// Makes an authenticated GET request with the given [session] to the
  /// resource located at [url] with the given [query] parameters.
  static Future<http.Response> getWithCookies(
    String baseUrl,
    Map<String, String> query,
    Session session,
  ) async {
    final loginSuccessful = await session.loginRequest;
    if (loginSuccessful != null && !loginSuccessful) {
      return Future.error('Login failed');
    }

    var url = !baseUrl.contains('?') ? '$baseUrl?' : baseUrl;
    query.forEach((key, value) {
      url += '$key=$value&';
    });
    if (query.isNotEmpty) {
      url = url.substring(0, url.length - 1);
    }

    final headers = <String, String>{};
    headers['cookie'] = session.cookies;

    final response = await (httpClient != null
        ? httpClient!.get(url.toUri(), headers: headers)
        : http.get(url.toUri(), headers: headers));
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 403 && !(await userLoggedIn(session))) {
      // HTTP403 - Forbidden
      final reLoginSuccessful = await reLogin(session);
      if (reLoginSuccessful) {
        headers['cookie'] = session.cookies;
        return http.get(url.toUri(), headers: headers);
      } else {
        NavigationService.logout();
        Logger().e('Login failed');
        return Future.error('Login failed');
      }
    } else {
      return Future.error('HTTP Error ${response.statusCode}');
    }
  }

  /// Check if the user is still logged in,
  /// performing a health check on the user's personal page.
  static Future<bool> userLoggedIn(Session session) async {
    final url =
        '${getBaseUrl(session.faculties[0])}fest_geral.cursos_list?pv_num_unico=${session.studentNumber}';
    final headers = <String, String>{};
    headers['cookie'] = session.cookies;
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
  static Future<Response> killAuthentication(List<String> faculties) async {
    final url = '${NetworkRouter.getBaseUrl(faculties[0])}vld_validacao.sair';
    final response = await http
        .get(url.toUri())
        .timeout(const Duration(seconds: loginRequestTimeout));
    if (response.statusCode == 200) {
      Logger().i('Logout Successful');
    } else {
      Logger().i('Logout Failed');
    }
    return response;
  }
}
