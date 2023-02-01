import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:uni/controller/fetchers/public_transportation_fetchers/public_transportation_fetcher.dart';
import 'package:uni/model/entities/stop.dart';
import 'package:uni/model/entities/route.dart';


class ExplorePortoAPIFetcher extends PublicTransportationFetcher{

  static final Uri _endpoint = Uri.https("otp.services.porto.digital", "/otp/routers/default/index/graphql");


  static TransportationType convertVehicleMode(String vehicleMode){
    switch(vehicleMode){
      case "BUS":
        return TransportationType.bus;
      case "SUBWAY":
        return TransportationType.subway;
      default:
        throw ArgumentError("vehicleMode: $vehicleMode is not a supported type..");
    }
  }

  @override
  Future<Map<String, Stop>> fetchStops() async{
    final Map<String, Stop> map = {};
    final response = await http.post(_endpoint,
      headers:  {"Content-Type": "application/json"}, 
      body: "{\"query\":\"{\\n\\tstops{gtfsId, name, code, vehicleMode, lat, lon}\\n}\",\"operationName\":\"\"}");
    if(response.statusCode != 200){
      return Future.error(HttpException("Explore.porto API returned status ${response.statusCode} while fetching stops..."));
    }
    final List<dynamic> responseStops = jsonDecode(response.body)['data']['stops'];
    responseStops.map((entry) => () {
      final TransportationType transportType = convertVehicleMode(entry['vehicleMode']);
      //when the stop is of a subway they have no code so we have to deal with it differently
      if(transportType == TransportationType.subway){
        return Stop(entry['gtfsId'], entry['name'], transportType, entry['latitude'], entry['longitude']);
      }
      return Stop(entry['gtfsId'], entry['code'], transportType, entry['latitude'], entry['longitude'], longName: entry['name']);

    });
    return map;
  }

  @override
  Future<Set<Route>> fetchRoutes(Map<String, Stop> stopMap) async {
    final Set<Route> routes = {};
    final response = await http.post(_endpoint, 
    headers: {"Content-Type": "application/json"}, 
    body: "{\"query\":\"{routes {gtfsId, longName, shortName, mode, patterns{code,stops{gtfsId},directionId}}}\\n\\n\"}");
    if(response.statusCode != 200){
      return Future.error(HttpException("Explore.porto API returned status ${response.statusCode} while fetching routes..."));
    }
    final List<dynamic> responseRoutes = jsonDecode(response.body)['data']['routes'];
    responseRoutes.map((entry) => (){
      final TransportationType transportType = convertVehicleMode(entry['vehicleMode']);
      final List<dynamic> patternsList = entry["patterns"];
      final List<RoutePattern> patterns = patternsList.map((e) {
        final LinkedHashSet<Stop> stops = LinkedHashSet.identity();
        for (dynamic stop in e['stops']){
          final Stop s = stopMap[stop['gtfsId']]!;
          stops.add(s);
        }
        return RoutePattern(e["code"], e['directionId'], stops);
      }).toList();
      final Route route = Route(
        entry['gtfsId'], 
        entry['shortName'], 
        transportType, 
        longName: entry['longName'],
        routePatterns: patterns
        );
      routes.add(route);
    });
    return routes;
  }



}