import 'dart:collection';

import 'package:uni/model/entities/stop.dart';

class RoutePattern{
  final String patternId;
  final int direction; //-1 for no direction (like a circular route); 0 for forward and 1 for backwards direction
  final LinkedHashSet<Stop> stops;

  final Map<String,dynamic> additionalInformation;

  RoutePattern(
    this.patternId, 
    this.direction, 
    this.stops, 
    {
      this.additionalInformation = const {},
  });

  Map<String, dynamic> toMap() => {
    'patternId': patternId,
    'direction': direction,
    'stops': stops.map((e) => e.code).toList(), //to later make it work with encodeJson()
    'additionalInformation': additionalInformation
  };

  static RoutePattern fromMap(Map<String, dynamic> map, Map<String, Stop> stops) => 
    RoutePattern(
      map['patternId'], 
      map['direction'], 
      LinkedHashSet.from((map['stops'] as List<String>).map((e) => stops[e]!).toList())
    );
}

class Route{
  final String code;
  final String name;
  final String longName;
  final TransportationType transportationType;
  final List<RoutePattern> routePatterns;

  Route(
    this.code, 
    this.name, 
    this.transportationType,
    {
      this.longName = '',
      this.routePatterns = const []
    }
  );

  Map<String, dynamic> toMap() => {
    'code':code,
    'name':name,
    'longName':longName,
    'transportationType':transportationType,
    'routePatterns': routePatterns.map((e) => e.toMap()).toList()
  };
  
  static Route fromMap(Map<String, dynamic> map, Map<String, Stop> stops) =>
    Route(
      map['code'],
      map['name'],
      TransportationType.values.byName(map['transportationType']),
      longName: map["longName"] ?? '',
      routePatterns: (map['routePatterns'] as List<Map<String,dynamic>>).map((e) => RoutePattern.fromMap(e, stops)).toList()
    );


  @override
  bool operator ==(Object other) => 
    identical(this, other) || other is Route &&
      code == other.code;
      
  @override
  int get hashCode => code.hashCode;
      
}