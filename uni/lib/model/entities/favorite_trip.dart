import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';

class TripSegment{
  final Stop initialStop;
  final Stop finalStop;
  final List<Route> possibleRoutes;

  TripSegment(
    this.initialStop, 
    this.finalStop, 
    this.possibleRoutes
  );

  Map<String, dynamic> toJson() => {
    'initialStop':initialStop.code,
    'finalStop':finalStop.code,
    'possibleRoutes':possibleRoutes.map((e) => e.code).toList()
  };

  static TripSegment fromJson(Map<String, dynamic> map, Map<String, Stop> stops, Map<String,Route> routes) =>
    TripSegment(
      stops[map['initialStop']!]!,
      stops[map['finalStop']!]!,
      List.from((map['possibleRoutes']! as List<String>).map((e) => routes[e]!))
    );

}

class FavoriteTrip{
  final String id;
  final List<TripSegment> routeDescription;

  FavoriteTrip(
    this.id, 
    this.routeDescription
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'routeDescription': routeDescription.map((e) => e.toJson()).toList()
  };

  static FavoriteTrip fromMap(Map<String, dynamic> map, Map<String, Stop> stops, Map<String,Route> routes) =>
    FavoriteTrip(
      map['id'], 
      List.from((map['routeDescription'] as List<Map<String,dynamic>>).map((e) => TripSegment.fromJson(e, stops, routes)))
    );
}