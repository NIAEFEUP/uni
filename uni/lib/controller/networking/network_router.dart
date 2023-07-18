import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
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
  /// The HTTP client used for all requests.
  /// Can be set to null to use the default client.
  /// This is useful for testing.
  static http.Client? httpClient;

  /// The timeout for Sigarra login requests.
  static const int loginRequestTimeout = 20;

  /// The mutual exclusion primitive for login requests.
  static Lock loginLock = Lock();

  /// Performs a login using the Sigarra API,
  /// returning an authenticated [Session] on the given [faculties] with the
  /// given username [username] and password [password] if successful.
  static Future<Session?> login(String username, String password,
      List<String> faculties, bool persistentSession) async {
    return loginLock.synchronized(() async {
      final String url =
          '${NetworkRouter.getBaseUrls(faculties)[0]}mob_val_geral.autentica';

      final http.Response response = await http.post(url.toUri(), body: {
        'pv_login': username,
        'pv_password': password
      }).timeout(const Duration(seconds: loginRequestTimeout));

      if (response.statusCode != 200) {
        Logger().e("Login failed with status code ${response.statusCode}");
        return null;
      }

      final Session? session =
          Session.fromLogin(response, faculties, persistentSession);
      if (session == null) {
        Logger().e('Login failed: user not authenticated');
        return null;
      }

      Logger().i('Login successful');
      return session;
    });
  }

  /// Re-authenticates the user via the Sigarra API
  /// using data stored in [session],
  /// returning an updated Session if successful.
  static Future<Session?> reLoginFromSession(Session session) async {
    final String username = session.username;
    final String password = await AppSharedPreferences.getUserPassword();
    final List<String> faculties = session.faculties;
    final bool persistentSession = session.persistentSession;

    Logger().i('Re-logging in user $username');

    return await login(username, password, faculties, persistentSession);
  }

  /// Returns the response body of the login in Sigarra
  /// given username [user] and password [pass].
  static Future<String> loginInSigarra(
      String user, String pass, List<String> faculties) async {
    return loginLock.synchronized(() async {
      final String url =
          '${NetworkRouter.getBaseUrls(faculties)[0]}vld_validacao.validacao';

      final response = await http.post(url.toUri(), body: {
        'p_user': user,
        'p_pass': pass
      }).timeout(const Duration(seconds: loginRequestTimeout));

      return response.body;
    });
  }

  /// Extracts the cookies present in [headers].
  static String extractCookies(Map<String, String> headers) {
    final List<String> cookieList = <String>[];
    final String? cookies = headers['set-cookie'];

    if (cookies != null && cookies != '') {
      final List<String> rawCookies = cookies.split(',');
      for (var c in rawCookies) {
        cookieList.add(Cookie.fromSetCookieValue(c).toString());
      }
    }

    return cookieList.join(';');
  }

  /// Makes an authenticated GET request with the given [session] to the
  /// resource located at [url] with the given [query] parameters.
  /// If the request fails with a 403 status code, the user is re-authenticated
  /// and the session is updated.
  static Future<http.Response> getWithCookies(
      String baseUrl, Map<String, String> query, Session session) async {
    if (!baseUrl.contains('?')) {
      baseUrl += '?';
    }
    String url = baseUrl;
    query.forEach((key, value) {
      url += '$key=$value&';
    });
    if (query.isNotEmpty) {
      url = url.substring(0, url.length - 1);
    }

    final Map<String, String> headers = <String, String>{};
    headers['cookie'] = session.cookies;

    final http.Response response = await (httpClient != null
        ? httpClient!.get(url.toUri(), headers: headers)
        : http.get(url.toUri(), headers: headers));

    if (response.statusCode == 200) {
      return response;
    }

    final forbidden = response.statusCode == 403;
    if (forbidden) {
      final userIsLoggedIn = await userLoggedIn(session);
      if (!userIsLoggedIn) {
        final Session? newSession = await reLoginFromSession(session);

        if (newSession == null) {
          NavigationService.logout();
          return Future.error('Login failed');
        }

        session.cookies = newSession.cookies;
        headers['cookie'] = session.cookies;
        return http.get(url.toUri(), headers: headers);
      } else {
        // If the user is logged in but still got a 403, they are forbidden to access the resource
        // or the login was invalid at the time of the request, but other thread re-authenticated.
        // Since we do not know which one is the case, we try again.
        headers['cookie'] = session.cookies;
        final response = await http.get(url.toUri(), headers: headers);
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
    return loginLock.synchronized(() async {
      final url =
          '${getBaseUrl(session.faculties[0])}fest_geral.cursos_list?pv_num_unico=${session.username}';
      final Map<String, String> headers = <String, String>{};
      headers['cookie'] = session.cookies;
      final http.Response response = await (httpClient != null
          ? httpClient!.get(url.toUri(), headers: headers)
          : http.get(url.toUri(), headers: headers));
      return response.statusCode == 200;
    });
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
  static Future killSigarraAuthentication(List<String> faculties) async {
    return loginLock.synchronized(() async {
      final url = '${NetworkRouter.getBaseUrl(faculties[0])}vld_validacao.sair';
      final response = await http
          .get(url.toUri())
          .timeout(const Duration(seconds: loginRequestTimeout));

      if (response.statusCode == 200) {
        Logger().i("Logout Successful");
      } else {
        Logger().i("Logout Failed");
      }

      return response;
    });
  }
}
