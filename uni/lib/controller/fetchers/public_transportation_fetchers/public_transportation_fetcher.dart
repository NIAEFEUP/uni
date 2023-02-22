

import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';

abstract class PublicTransportationFetcher{

  final String providerName;

  PublicTransportationFetcher(this.providerName);


  Future<Map<String, Stop>> fetchStops();

  Future<Map<String,Route>> fetchRoutes(Map<String,Stop> stopMap);

  Future<void> fetchRoutePatternTimetable(RoutePattern routePattern);


}