import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_feup/controller/local_storage/AppSharedPreferences.dart';
import 'package:app_feup/model/entities/CourseUnit.dart';
import 'package:app_feup/model/entities/Profile.dart';
import 'package:app_feup/model/entities/Session.dart';
import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';
import 'package:synchronized/synchronized.dart';

class NetworkRouter {

  static const int timeout = 20;

  static Lock loginLock = Lock();

  static Function onReloginFail = (){};

  static Future<Session> login(
      String user, String pass, String faculty, bool persistentSession) async {
    final String url =
        NetworkRouter.getBaseUrl(faculty) + 'mob_val_geral.autentica';
    final http.Response response =
        await http.post(url, body: {"pv_login": user, "pv_password": pass}).timeout(const Duration(seconds: timeout));
    if (response.statusCode == 200) {
      final Session session = Session.fromLogin(response);
      session.persistentSession = persistentSession;
      print('Login successful');
      return session;
    } else {
      print('Login failed');
      return Session(authenticated: false);
    }
  }

  static Future<bool> relogin(Session session) async {
    return loginLock.synchronized(() async {
      if (!session.persistentSession) {
        return false;
      }

      if (session.loginRequest != null) {
        return session.loginRequest;
      } else {
        return session.loginRequest = loginFromSession(session).then((_) {session.loginRequest = null;});
      }
    });
  }

  static Future<bool> loginFromSession(Session session) async {
    print('Trying to login...');
    final String url =
          NetworkRouter.getBaseUrl(session.faculty) + 'mob_val_geral.autentica';
      final http.Response response = await http.post(url, body: {
        "pv_login": session.studentNumber,
        "pv_password": await AppSharedPreferences.getUserPassword(),
      }).timeout(const Duration(seconds: timeout));
      if (response.statusCode == 200) {
        session.setCookies(NetworkRouter.extractCookies(response.headers));
        print('Re-login successful');
        return true;
      } else {
        print('Re-login failed');
        return false;
      }
  }

  static String extractCookies(dynamic headers) {
    final List<String> cookieList = List<String>();
    final String cookies = headers['set-cookie'];
    if (cookies != null) {
      final List<String> rawCookies = cookies.split(',');
      for (var c in rawCookies) {
        cookieList.add(Cookie.fromSetCookieValue(c).toString());
      }
    }
    return cookieList.join(';');
  }

  static Future<Profile> getProfile(Session session) async {
    final url =
        NetworkRouter.getBaseUrlFromSession(session) + 'mob_fest_geral.perfil?';
    final response = await getWithCookies(
        url, {"pv_codigo": session.studentNumber}, session);

    if (response.statusCode == 200) {
      return Profile.fromResponse(response);
    }
    return Profile();
  }

  static Future<List<CourseUnit>> getCurrentCourseUnits(Session session) async {
    final url = NetworkRouter.getBaseUrlFromSession(session) +
        'mob_fest_geral.ucurr_inscricoes_corrente?';
    final response = await getWithCookies(
        url, {"pv_codigo": session.studentNumber}, session);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      List<CourseUnit> ucs = List<CourseUnit>();
      for (var course in responseBody) {
        for (var uc in course['inscricoes']) {
          ucs.add(CourseUnit.fromJson(uc));
        }
      }
      return ucs;
    }
    return List<CourseUnit>();
  }

  static Future<http.Response> getWithCookies(
      String baseUrl, Map<String, String> query, Session session) async {
    final loginSuccessful = await session.loginRequest;
    if (loginSuccessful is bool && !loginSuccessful)
      return Future.error('Login failed');

    final URLQueryParams params = new URLQueryParams();
    query.forEach((key, value) {
      params.append(key, value);
    });

    final url = baseUrl + params.toString();

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] = session.cookies;
    final http.Response response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 403) {
      // HTTP403 - Forbidden
      final bool success = await relogin(session);
      if (success) {
        headers['cookie'] = session.cookies;
        return http.get(url, headers: headers);
      } else {
        onReloginFail();
        print('Login failed');
        return Future.error('Login failed');
      }
    } else {
      return Future.error('HTTP Error ${response.statusCode}');
    }
  }

  static String getBaseUrl(String faculty) {
    return 'https://sigarra.up.pt/$faculty/pt/';
  }

  static String getBaseUrlFromSession(Session session) {
    return NetworkRouter.getBaseUrl(session.faculty);
  }
}
