import 'package:uni/model/entities/stop.dart';

class Route{
  final String code;
  final String name;
  final String longName;
  final TransportationType transportationType;
  final bool direction;
  final Set<Stop> stops;

  Route(
    this.code, 
    this.name, 
    this.direction,
    this.transportationType,
    this.stops,
    {
      this.longName = ''
    }
  );

  Map<String, dynamic> toMap() => {
    'code':code,
    'name':name,
    'longName':longName,
    'transportationType':transportationType,
    'direction': direction,
    'stops': stops.join(";")
  };
  
  static Route fromMap(Map<String, dynamic> map, Map<String, Stop> stops) =>
    Route(
      map['code'],
      map['name'],
      map['direction'],
      TransportationType.values.byName(map['transportationType']),
      (map['stops'] as String).split(";").map((e) => stops[e]!).toSet()
    );
    

  @override
  bool operator ==(Object other) => 
    identical(this, other) || other is Route &&
      code == other.code;
      
  @override
  int get hashCode => code.hashCode;
      
}