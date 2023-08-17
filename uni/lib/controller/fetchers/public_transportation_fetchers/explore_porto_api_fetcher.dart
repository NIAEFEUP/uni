import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/public_transportation_fetchers/public_transportation_fetcher.dart';
import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';

// ignore_for_file: avoid_dynamic_calls

class ExplorePortoAPIFetcher extends PublicTransportationFetcher {
  ExplorePortoAPIFetcher() : super('explorePorto');

  static final Uri _endpoint = Uri.https(
      'otp.services.porto.digital', '/otp/routers/default/index/graphql');

  static TransportationType convertVehicleMode(String vehicleMode) {
    switch (vehicleMode) {
      case 'BUS':
        return TransportationType.bus;
      case 'SUBWAY':
        return TransportationType.subway;
      case 'TRAM':
        return TransportationType.tram;
      case 'FUNICULAR':
        return TransportationType.funicular;
      default:
        throw ArgumentError(
          'vehicleMode: $vehicleMode is not a supported type..',
        );
    }
  }

  @override
  Future<Map<String, Stop>> fetchStops() async {
    final map = <String, Stop>{};
    final response = await http.post(
      _endpoint,
      headers: {'Content-Type': 'application/json'},
      body: r'{"query":"{stops{gtfsId, name, code, vehicleMode, lat, lon}\n}"}',
    );
    if (response.statusCode != 200) {
      return Future.error(
        HttpException('Explore.porto API returned status '
            '${response.statusCode} while fetching stops...'),
      );
    }
    final responseStops =
        jsonDecode(response.body)['data']['stops'] as List<dynamic>;
    for (final dynamic entry in responseStops) {
      final transportType = convertVehicleMode(entry['vehicleMode'] as String);
      // when the stop is of a subway they have no code so we have to deal with
      // it differently
      if (transportType == TransportationType.subway ||
          transportType == TransportationType.funicular) {
        map.putIfAbsent(
          entry['gtfsId'] as String,
          () => Stop(
            entry['gtfsId'] as String,
            entry['name'] as String,
            transportType,
            entry['lat'] as double,
            entry['lon'] as double,
            providerName,
          ),
        );
      } else {
        map.putIfAbsent(
          entry['gtfsId'] as String,
          () => Stop(
              entry['gtfsId'] as String,
              entry['code'] as String,
              transportType,
              entry['lat'] as double,
              entry['lon'] as double,
              providerName,
              longName: entry['name'] as String),
        );
      }
    }
    return map;
  }

  @override
  Future<Map<String, Route>> fetchRoutes(Map<String, Stop> stopMap) async {
    final routes = <String, Route>{};
    final response = await http.post(
      _endpoint,
      headers: {'Content-Type': 'application/json'},
      body: '{"query":"{routes {gtfsId, longName, shortName, mode,'
          ' patterns{code,stops{gtfsId},directionId}}}"}',
    );
    if (response.statusCode != 200) {
      return Future.error(
        HttpException('Explore.porto API returned status ${response.statusCode}'
            ' while fetching routes...'),
      );
    }
    final responseRoutes =
        jsonDecode(response.body)['data']['routes'] as List<dynamic>;
    for (final dynamic entry in responseRoutes) {
      final transportType = convertVehicleMode(entry['mode'] as String);
      final patternsList = entry['patterns'] as List<dynamic>;
      final patterns = patternsList.map((e) {
        final stops = LinkedHashSet<Stop>.identity();
        for (final dynamic stop in e['stops'] as List<dynamic>) {
          final s = stopMap[stop['gtfsId']];
          if (s == null) {
            Logger().e("Couldn't find stop ${stop['gtfsId']}"
                " on route ${entry['gtfsId']}...");
            continue;
          }
          stops.add(s);
        }
        return RoutePattern(
          e['code'] as String,
          e['directionId'] as int,
          stops,
          providerName,
          {},
        );
      }).toList();
      final route = Route(
        entry['gtfsId'] as String,
        entry['shortName'] as String,
        transportType,
        providerName,
        longName: entry['longName'] as String,
        routePatterns: patterns,
      );
      routes.putIfAbsent(entry['gtfsId'] as String, () => route);
    }
    return routes;
  }

  @override
  Future<void> fetchRoutePatternTimetable(RoutePattern routePattern) async {
    final response = await http.post(
      _endpoint,
      headers: {'Content-Type': 'application/json'},
      body: '{"query":"{pattern(id: "${routePattern.patternId}") '
          '{trips{activeDates,stoptimes{scheduledArrival,serviceDay}}}}"}',
    );
    if (response.statusCode != 200) {
      return Future.error(
        HttpException('Explore.porto API returned status ${response.statusCode}'
            ' while fetching timetable...'),
      );
    }
    final trips = jsonDecode(response.body)['data']['pattern'] as List<dynamic>;

    //format using in date
    final dateFormat = DateFormat('yMMd');

    for (final dynamic trip in trips) {
      final stoptimes = (trip['stoptimes'] as List<Map<String, int>>)
          .map((e) => e['scheduledArrival']!)
          .toList();
      final serviceDates =
          (trip['activeDates'] as List<String>).map(dateFormat.parse).toList();

      for (final serviceDate in serviceDates) {
        if (routePattern.timetable.containsKey(serviceDate)) {
          routePattern.timetable[serviceDate]!.add(stoptimes);
        } else {
          routePattern.timetable[serviceDate] = {stoptimes};
        }
      }
    }
  }
}
