



enum TransportationType{
  train,
  bus,
  metro
}

class Stop{

  final String code;
  final String name;
  final String longName;
  final TransportationType transportationType;
  final double latitude;
  final double longitude;

  Stop(
    this.code,
    this.name, 
    this.transportationType, 
    this.latitude, 
    this.longitude,
    {
      this.longName = '',
    }
  );

  Map<String, dynamic> toMap(){
    return {
      'code':code,
      'name':name,
      'longName':longName,
      'transportationType':transportationType.name,
      'latitude':latitude,
      'longitude':longitude,
    };
  }

  static Stop fromMap(Map<String, dynamic> map) =>
    Stop(
      map['code'],
      map['name'],
      TransportationType.values.byName(map['transportationType']),
      map['latitude'],
      map['longitude'],
      longName: map['longName'],
    );

  @override
  bool operator ==(Object other) =>
    identical(other, this) || 
    other is Stop &&
    code == other.code;

  
  @override
  int get hashCode => 
    code.hashCode;

  @override
  String toString(){
    return code;
  }
}