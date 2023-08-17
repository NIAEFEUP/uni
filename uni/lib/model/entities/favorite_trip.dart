import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';

class TripSegment {
  TripSegment(
    this.initialStop,
    this.finalStop,
    this.possibleRoutes,
  );

  factory TripSegment.fromJson(Map<String, dynamic> map,
          Map<String, Stop> stops, Map<String, Route> routes,) =>
      TripSegment(
        stops[map['initialStop']!]!,
        stops[map['finalStop']!]!,
        List.from(
            (map['possibleRoutes']! as List<String>).map((e) => routes[e]!),),
      );

  final Stop initialStop;
  final Stop finalStop;
  final List<Route> possibleRoutes;

  Map<String, dynamic> toJson() => {
        'initialStop': initialStop.code,
        'finalStop': finalStop.code,
        'possibleRoutes': possibleRoutes.map((e) => e.code).toList()
      };
}

class FavoriteTrip {
  FavoriteTrip(
    this.id,
    this.routeDescription,
  );

  factory FavoriteTrip.fromMap(
    Map<String, dynamic> map,
    Map<String, Stop> stops,
    Map<String, Route> routes,
  ) =>
      FavoriteTrip(
        map['id'] as String,
        List.from(
          (map['routeDescription'] as List<Map<String, dynamic>>)
              .map((e) => TripSegment.fromJson(e, stops, routes)),
        ),
      );

  final String id;
  final List<TripSegment> routeDescription;

  Map<String, dynamic> toMap() => {
        'id': id,
        'routeDescription': routeDescription.map((e) => e.toJson()).toList()
      };
}
