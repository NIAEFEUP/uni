import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:uni/controller/bus_stops/departures_fetcher.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/bus.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';
import 'package:synchronized/synchronized.dart';

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
  static Future<Session> login(
      String user, String pass, String faculty, bool persistentSession) async {
    final String url =
        NetworkRouter.getBaseUrl(faculty) + 'mob_val_geral.autentica';
    final http.Response response = await http.post(url.toUri(), body: {
      'pv_login': user,
      'pv_password': pass
    }).timeout(const Duration(seconds: loginRequestTimeout));
    if (response.statusCode == 200) {
      final Session session = Session.fromLogin(response);
      session.persistentSession = persistentSession;
      Logger().i('Login successful');
      return session;
    } else {
      Logger().e('Login failed');
      return Session(authenticated: false);
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
    final String url =
        NetworkRouter.getBaseUrl(session.faculty) + 'mob_val_geral.autentica';
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

  /// Returns the user's [Profile].
  static Future<Profile> getProfile(Session session) async {
    final url =
        NetworkRouter.getBaseUrlFromSession(session) + 'mob_fest_geral.perfil?';
    final response = await getWithCookies(
        url, {'pv_codigo': session.studentNumber}, session);

    if (response.statusCode == 200) {
      return Profile.fromResponse(response);
    }
    return Profile();
  }

  /// Returns the user's current list of [CourseUnit].
  static Future<List<CourseUnit>> getCurrentCourseUnits(Session session) async {
    final url = NetworkRouter.getBaseUrlFromSession(session) +
        'mob_fest_geral.ucurr_inscricoes_corrente?';
    final response = await getWithCookies(
        url, {'pv_codigo': session.studentNumber}, session);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<CourseUnit> ucs = <CourseUnit>[];
      for (var course in responseBody) {
        for (var uc in course['inscricoes']) {
          ucs.add(CourseUnit.fromJson(uc));
        }
      }
      return ucs;
    }
    return <CourseUnit>[];
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

  /// Retrieves the name and code of the stops with code [stopCode].
  static Future<List<String>> getStopsByName(String stopCode) async {
    final List<String> stopsList = [];

    //Search by aproximate name
    final String url =
        'https://www.stcp.pt/pt/itinerarium/callservice.php?action=srchstoplines&stopname=$stopCode';
    final http.Response response = await http.post(url.toUri());
    final List json = jsonDecode(response.body);
    for (var busKey in json) {
      final String stop = busKey['name'] + ' [' + busKey['code'] + ']';
      stopsList.add(stop);
    }

    return stopsList;
  }

  /// Retrieves real-time information about the user's selected bus lines.
  static Future<List<Trip>> getNextArrivalsStop(
      String stopCode, BusStopData stopData) {
    return DeparturesFetcher(stopCode, stopData).getDepartures();
  }

  /// Returns the bus lines that stop at the given [stop].
  static Future<List<Bus>> getBusesStoppingAt(String stop) async {
    final String url =
        'https://www.stcp.pt/pt/itinerarium/callservice.php?action=srchstoplines&stopcode=$stop';
    final http.Response response = await http.post(url.toUri());

    final List json = jsonDecode(response.body);

    final List<Bus> buses = [];

    for (var busKey in json) {
      final lines = busKey['lines'];
      for (var bus in lines) {
        final Bus newBus = Bus(
            busCode: bus['code'],
            destination: bus['description'],
            direction: (bus['dir'] == 0 ? false : true));
        buses.add(newBus);
      }
    }

    return buses;
  }

  /// Returns the base url of the user's faculty.
  static String getBaseUrl(String faculty) {
    return 'https://sigarra.up.pt/$faculty/pt/';
  }

  /// Returns the base url from the user's previous session.
  static String getBaseUrlFromSession(Session session) {
    return NetworkRouter.getBaseUrl(session.faculty);
  }
}
