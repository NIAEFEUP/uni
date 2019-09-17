import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_feup/model/entities/Bus.dart';
import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/model/entities/CourseUnit.dart';
import 'package:app_feup/model/entities/Profile.dart';
import 'package:app_feup/model/entities/Session.dart';
import 'package:app_feup/model/entities/Trip.dart';
import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';

class NetworkRouter {
  static Future<Session> login(
      String user, String pass, String faculty, bool persistentSession) async {
    final String url =
        NetworkRouter.getBaseUrl(faculty) + 'mob_val_geral.autentica';
    final http.Response response =
        await http.post(url, body: {"pv_login": user, "pv_password": pass});
    if (response.statusCode == 200) {
      final Session session = Session.fromLogin(response);
      if (persistentSession) {
        session.setPersistentSession(pass);
      }
      print('Login successful');
      return session;
    } else {
      print('Login failed');
      return Session(authenticated: false);
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
        url, {"pv_codigo": session.studentNumber}, session.cookies);

    if (response.statusCode == 200) {
      return Profile.fromResponse(response);
    }
    return Profile();
  }

  static Future<List<CourseUnit>> getCurrentCourseUnits(Session session) async {
    final url = NetworkRouter.getBaseUrlFromSession(session) +
        'mob_fest_geral.ucurr_inscricoes_corrente?';
    final response = await getWithCookies(
        url, {"pv_codigo": session.studentNumber}, session.cookies);
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
      String baseUrl, Map<String, String> query, String cookies) {
    final URLQueryParams params = new URLQueryParams();
    query.forEach((key, value) {
      params.append(key, value);
    });

    final url = baseUrl + params.toString();

    final Map<String, String> headers = Map<String, String>();
    headers['cookie'] = cookies;

    return http.get(url, headers: headers);
  }

  static Future<List<String>> getStopsByName(String stopCode) async {
    List<String> stopsList = new List();

    //Search by exact stopCode
    final String url1 = "https://www.stcp.pt/pt/itinerarium/callservice.php?action=srchstoplines&stopcode=$stopCode";
    http.Response response1 = await http.post(url1);
    var json1 = jsonDecode(response1.body) as List;
    if(json1.length != 0)
      stopsList.add(json1[0]['name'] + " [" + json1[0]['code'] + "]");

    //Search by aproximate name
    final String url2 = "https://www.stcp.pt/pt/itinerarium/callservice.php?action=srchstoplines&stopname=$stopCode";
    http.Response response2 = await http.post(url2);
    var json2 = jsonDecode(response2.body);
    for (var busKey in json2) {
      String stop = busKey['name'] + " [" + busKey['code'] + "]";
      stopsList.add(stop);
    }

    return stopsList;
  }

  static Future<List<Trip>> getNextArrivalsStop(BusStop stop) async {
    final String url = "http://move-me.mobi/NextArrivals/GetScheds?providerName=STCP&stopCode=STCP_" + stop.getStopCode();
    http.Response response = await http.get(url);
    List<Trip> tripList = new List();

    var json = jsonDecode(response.body);

    for (var TripKey in json) {
      var trip = TripKey['Value'];
      String line = trip[0];
      if(stop.getBuses().map((bus) => bus.busCode).toList().contains(line)) {
        String destination = trip[1];
        String timeString = trip[2];
        if (timeString.substring(timeString.length - 1) == '*')
          timeString = timeString.substring(0, timeString.length - 1);
        int timeRemaining = int.parse(timeString);
        Trip newTrip = Trip(
            line: line, destination: destination, timeRemaining: timeRemaining);
        newTrip.printTrip();
        tripList.add(newTrip);
      }
    }

    tripList.sort((a, b) => a.compare(b));
    return tripList;
  }

  static Future<List<Bus>> getBusesStoppingAt(String stop) async {
    final String url = "https://www.stcp.pt/pt/itinerarium/callservice.php?action=srchstoplines&stopcode=$stop";
    http.Response response = await http.post(url);
    List<Trip> tripList = new List();

    var json = jsonDecode(response.body);

    List<Bus> buses = new List();

    for (var busKey in json) {
      var lines = busKey['lines'];
      for (var bus in lines) {
        Bus newBus = Bus(bus['code'], bus['description'], (bus['dir']==0?false:true));
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
