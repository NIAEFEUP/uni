import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/io_client.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/bus.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/trip.dart';

class DeparturesFetcher {
  DeparturesFetcher(this._stopCode, this._stopData);

  final String _stopCode;
  final BusStopData _stopData;
  static final _client = http.IOClient(
    HttpClient(context: SecurityContext())
      ..badCertificateCallback =
          (cert, host, port) => host == 'www.stcp.pt' && port == 443,
  );

  Future<String> _getCSRFToken() async {
    final url =
        'https://www.stcp.pt/en/travel/timetables/?paragem=$_stopCode&t=smsbus';

    final response = await _client.get(url.toUri());
    final htmlResponse = parse(response.body);
    try {
      final scriptText = htmlResponse
          .querySelectorAll('table script')
          .where((element) => element.text.contains(_stopCode))
          .map((e) => e.text)
          .first;

      final callParam = scriptText
          .substring(scriptText.indexOf('('))
          .split(',')
          .firstWhere((element) => element.contains(')'));

      final csrfToken = callParam.substring(
        callParam.indexOf("'") + 1,
        callParam.lastIndexOf("'"),
      );
      return csrfToken;
    } catch (e, stackTrace) {
      unawaited(
        Sentry.captureEvent(
          SentryEvent(
            throwable: e,
            request: SentryRequest(
              url: url,
              data: response.body,
            ),
          ),
          stackTrace: stackTrace,
        ),
      );
      rethrow;
    }
  }

  void throwCSRFTokenError() {
    throw Exception('No CSRF token found!');
  }

  Future<List<Trip>> getDepartures() async {
    final csrfToken = await _getCSRFToken();

    final url =
        'https://www.stcp.pt/pt/itinerarium/soapclient.php?codigo=$_stopCode&hash123=$csrfToken';

    final response = await _client.get(url.toUri());
    final htmlResponse = parse(response.body);

    final tableEntries =
        htmlResponse.querySelectorAll('#smsBusResults > tbody > tr.even');

    final configuredBuses = _stopData.configuredBuses;

    final tripList = <Trip>[];

    for (final entry in tableEntries) {
      final rawBusInformation = entry.querySelectorAll('td');

      final busLine =
          rawBusInformation[0].querySelector('ul > li')?.text.trim();

      if (!configuredBuses.contains(busLine)) {
        continue;
      }

      final busDestination = rawBusInformation[0]
          .text
          .replaceAll('\n', '')
          .replaceAll('\t', '')
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .substring(busLine!.length + 1);

      final busTimeRemaining = _getBusTimeRemaining(rawBusInformation);

      final newTrip = Trip(
        line: busLine,
        destination: busDestination,
        timeRemaining: busTimeRemaining,
      );

      tripList.add(newTrip);
    }
    return tripList;
  }

  /// Extracts the time remaining for a bus to reach a stop.
  static int _getBusTimeRemaining(List<Element> rawBusInformation) {
    if (rawBusInformation[1].text.trim() == 'a passar') {
      return 0;
    } else {
      final regex = RegExp('([0-9]+)');

      return int.parse(
        regex.stringMatch(rawBusInformation[2].text).toString(),
      );
    }
  }

  /// Retrieves the name and code of the stops with code [stopCode].
  static Future<List<String>> getStopsByName(String stopCode) async {
    final stopsList = <String>[];

    // Search by approximate name
    final url =
        'https://www.stcp.pt/pt/itinerarium/callservice.php?action=srchstoplines&stopname=$stopCode';

    final response = await _client.post(url.toUri());
    final json = jsonDecode(response.body) as List<dynamic>;
    for (final busKey in json) {
      final bus = busKey as Map<String, dynamic>;
      final stopDescription = '${bus['name']} [${bus['code']}]';
      stopsList.add(stopDescription);
    }

    return stopsList;
  }

  /// Retrieves real-time information about the user's selected bus lines.
  static Future<List<Trip>> getNextArrivalsStop(
    String stopCode,
    BusStopData stopData,
  ) {
    return DeparturesFetcher(stopCode, stopData).getDepartures();
  }

  /// Returns the bus lines that stop at the given [stop].
  static Future<List<Bus>> getBusesStoppingAt(String stop) async {
    final url =
        'https://www.stcp.pt/pt/itinerarium/callservice.php?action=srchstoplines&stopcode=$stop';

    final response = await _client.post(url.toUri());

    final json = jsonDecode(response.body) as List<dynamic>;

    final buses = <Bus>[];

    for (final data in json) {
      final lines = (data as Map<String, dynamic>)['lines'] as List<dynamic>;
      for (final busInfo in lines) {
        final bus = busInfo as Map<String, dynamic>;
        final newBus = Bus(
          busCode: bus['code'] as String,
          destination: bus['description'] as String,
          direction: bus['dir'] != 0,
        );
        buses.add(newBus);
      }
    }

    return buses;
  }
}
