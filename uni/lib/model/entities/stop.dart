enum TransportationType { train, bus, subway, tram, funicular }

class Stop {
  Stop(
    this.code,
    this.name,
    this.transportationType,
    this.latitude,
    this.longitude,
    this.providerName, {
    this.longName = '',
  });

  factory Stop.fromMap(Map<String, dynamic> map) => Stop(
        map['code'] as String,
        map['name'] as String,
        TransportationType.values.byName(map['transportationType'] as String),
        map['latitude'] as double,
        map['longitude'] as double,
        map['providerName'] as String,
        longName: map['longName'] as String,
      );

  final String code;
  final String name;
  final String longName;
  final String providerName;
  final TransportationType transportationType;
  final double latitude;
  final double longitude;

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'longName': longName,
      'transportationType': transportationType.name,
      'latitude': latitude,
      'longitude': longitude,
      'providerName': providerName
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(other, this) || other is Stop && code == other.code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return code;
  }
}
