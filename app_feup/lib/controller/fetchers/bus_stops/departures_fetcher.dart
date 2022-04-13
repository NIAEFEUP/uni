import 'package:uni/model/entities/bus_stop.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/controller/networking/network_router.dart';

class DeparturesFetcher {
  final String _stopCode;
  final BusStopData _stopData;

  DeparturesFetcher(this._stopCode, this._stopData);

  Future<String> _getCSRFToken() async {
    final url =
        'https://www.stcp.pt/en/travel/timetables/?paragem=$_stopCode&t=smsbus';

    final http.Response response = await http.get(url.toUri());
    final htmlResponse = parse(response.body);

    final scriptText = htmlResponse
        .querySelectorAll('script')
        .where((element) => element.text.contains(_stopCode))
        .map((e) => e.text)
        .first;

    final callParam = scriptText
        .substring(scriptText.indexOf('('))
        .split(',')
        .firstWhere((element) => element.contains(')'));

    final csrfToken = callParam.substring(
        callParam.indexOf('\'') + 1, callParam.lastIndexOf('\''));

    return csrfToken;
  }

  void throwCSRFTokenError() {
    throw Exception('No CSRF token found!');
  }

  Future<List<Trip>> getDepartures() async {
    final csrfToken = await _getCSRFToken();

    final url =
        'https://www.stcp.pt/pt/itinerarium/soapclient.php?codigo=$_stopCode&hash123=$csrfToken';

    final http.Response response = await http.get(url.toUri());
    final htmlResponse = parse(response.body);

    final tableEntries =
        htmlResponse.querySelectorAll('#smsBusResults > tbody > tr.even');

    final configuredBuses = _stopData.configuredBuses;

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

  /// Extracts the time remaining for a bus to reach a stop.
  static int getBusTimeRemaining(rawBusInformation) {
    if (rawBusInformation[1].text.trim() == 'a passar') {
      return 0;
    } else {
      final regex = RegExp(r'([0-9]+)');

      return int.parse(regex.stringMatch(rawBusInformation[2].text).toString());
    }
  }
}
