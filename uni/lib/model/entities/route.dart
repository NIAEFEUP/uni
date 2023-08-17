import 'dart:collection';
import 'dart:convert';
import 'package:uni/model/entities/stop.dart';

class RoutePattern {
  RoutePattern(
    this.patternId,
    this.direction,
    this.stops,
    this.providerName,
    this.timetable, {
    this.additionalInformation = const {},
  });

  factory RoutePattern.fromMap(
    Map<String, dynamic> map,
    Map<String, Stop> stops,
    String providerName,
  ) =>
      RoutePattern(
        map['patternId'] as String,
        map['direction'] as int,
        LinkedHashSet.from(
          (map['stops'] as List<dynamic>).map((e) => stops[e]),
        ),
        providerName,
        Map.from(
          (map['timeTable'] as Map<String, List<List<int>>>)
              .map((key, value) => MapEntry(key, value.toSet())),
        ),
      );

  final String patternId;
  //-1 for no direction (like a circular route); 0 for forward and 1
  //for backwards direction
  final int direction;
  final String providerName;
  // TODO(luisd): remove datetimes that already passed
  final LinkedHashSet<Stop> stops;
  //this is pratically an implementation of an ArrayListMultiMap in java
  final Map<DateTime, Set<List<int>>> timetable;
  final Map<String, dynamic> additionalInformation;

  Map<String, dynamic> toMap() => {
        'patternId': patternId,
        'direction': direction,
        //to later make it work with encodeJson()
        'stops': stops.map((e) => e.code).toList(),
        'timetable': jsonEncode(
          timetable.map(
            (key, value) =>
                MapEntry<DateTime, List<List<int>>>(key, value.toList()),
          ),
        ),
        'additionalInformation': additionalInformation
      };
}

class Route {
  Route(
    this.code,
    this.name,
    this.transportationType,
    this.providerName, {
    this.longName = '',
    this.routePatterns = const [],
  });

  factory Route.fromMap(Map<String, dynamic> map, Map<String, Stop> stops) =>
      Route(
        map['code'] as String,
        map['name'] as String,
        TransportationType.values.byName(map['transportationType'] as String),
        map['providerName'] as String,
        longName: map['longName'] as String? ?? '',
        routePatterns: (map['routePatterns'] as List<Map<String, dynamic>>)
            .map(
              (e) =>
                  RoutePattern.fromMap(e, stops, map['providerName'] as String),
            )
            .toList(),
      );

  final String code;
  final String name;
  final String longName;
  final String providerName;
  final TransportationType transportationType;
  final List<RoutePattern> routePatterns;

  Map<String, dynamic> toMap() => {
        'code': code,
        'name': name,
        'longName': longName,
        'providerName': providerName,
        'transportationType': transportationType.name,
        'routePatterns':
            jsonEncode(routePatterns.map((e) => e.toMap()).toList())
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Route && code == other.code;

  @override
  int get hashCode => code.hashCode;
}
