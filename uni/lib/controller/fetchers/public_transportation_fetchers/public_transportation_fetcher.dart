

import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';

abstract class PublicTransportationFetcher{

  Future<Map<String, Stop>> fetchStops();

  Future<Map<String,Route>> fetchRoutes(Map<String,Stop> stopMap);


}