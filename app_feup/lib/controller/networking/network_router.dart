import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html/dom.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/bus.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:query_params/query_params.dart';
import 'package:synchronized/synchronized.dart';

extension UriString on String {
  Uri toUri() => Uri.parse(this);
}

class NetworkRouter {
  static http.Client httpClient;

  static const int loginRequestTimeout = 20;

  static Lock loginLock = Lock();

  static Function onReloginFail = () {};

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

  static Future<List<Trip>> getNextArrivalsStop(
      String stopCode, BusStopData stopData) async {
    final url =
        'https://www.stcp.pt/pt/itinerarium/soapclient.php?codigo=' + stopCode;

    final http.Response response = await http.get(url.toUri());
    final htmlResponse = parse(response.body);

    final tableEntries =
        htmlResponse.querySelectorAll('#smsBusResults > tbody > tr.even');

    final configuredBuses = stopData.configuredBuses;

    final tripList = <Trip>[];

    for (var entry in tableEntries) {
      final rawBusInformation = entry.querySelectorAll('td');

      final busLine = rawBusInformation[0].querySelector('ul > li').text.trim();

      if (!configuredBuses.contains(busLine)) {
        continue;
      }

      final busDestination = rawBusInformation[0]
          .text
          .replaceAll('\n', '')
          .replaceAll('\t', '')
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .substring(busLine.length + 1);

      final busTimeRemaining = getBusTimeRemaining(rawBusInformation);

      final Trip newTrip = Trip(
          line: busLine,
          destination: busDestination,
          timeRemaining: busTimeRemaining);

      tripList.add(newTrip);
    }

    return tripList;
  }

  static Future<List<Trip>> getNexArrivalsAfterLoadingJS(
      String stopCode, BusStopData stopData) async {
    final flutterWebviewPlugin = FlutterWebviewPlugin();

    flutterWebviewPlugin.launch(
        'https://www.stcp.pt/en/travel/timetables/?paragem=' +
            stopCode +
            '&t=smsbus',
        hidden: true);
    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        flutterWebviewPlugin
            //.evalJavascript('document.documentElement.innerHTML')
            .evalJavascript(
                "document.querySelector('#paragem_info_result').innerHTML")
            .then((html) {
          final htmlNew = html
              .replaceAll('\\t', '')
              .replaceAll('\\n', '')
              .replaceAll('\\u', '')
              .replaceAll('\\', '')
              .replaceAll('003C', '<')
              .replaceAll('-', '')
              .trim();

          final htmlResponse = parseFragment(htmlNew);

          final tableEntries =
              htmlResponse.querySelectorAll('#smsBusResults > tbody > tr.even');

          final configuredBuses = stopData.configuredBuses;

          final tripList = <Trip>[];

          for (var entry in tableEntries) {
            final rawBusInformation = entry.querySelectorAll('td');

            final busLine =
                rawBusInformation[0].querySelector('ul > li').text.trim();

            if (!configuredBuses.contains(busLine)) {
              continue;
            }

            final busDestination = rawBusInformation[0].text;

            final busTimeRemaining = getBusTimeRemaining(rawBusInformation);
            final Trip newTrip = Trip(
                line: busLine,
                destination: busDestination,
                timeRemaining: busTimeRemaining);

            tripList.add(newTrip);
          }

          flutterWebviewPlugin.close();

          for (Trip t in tripList) {
            print('TRIP LIST ROUTER ' + t.toString());
          }

          //TODO FAZER COM QUE A FUNÇÃO RETORNE ESTE TRIP LIST
          // SO DEVE RETORNAR DEPOIS DE TER ACABADO DE DAR LOAD AO JAVASCRIPT DA PAGINA
          return tripList;
        });
        //log('HTML String' + htmlResponse.outerHtml);
      }
    });
  }

  static int getBusTimeRemaining(rawBusInformation) {
    if (rawBusInformation[1].text.trim() == 'a passar') {
      return 0;
    } else {
      final regex = RegExp(r'([0-9]+)');

      return int.parse(regex.stringMatch(rawBusInformation[2].text).toString());
    }
  }

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

  static String getBaseUrl(String faculty) {
    return 'https://sigarra.up.pt/$faculty/pt/';
  }

  static String getBaseUrlFromSession(Session session) {
    return NetworkRouter.getBaseUrl(session.faculty);
  }
}
