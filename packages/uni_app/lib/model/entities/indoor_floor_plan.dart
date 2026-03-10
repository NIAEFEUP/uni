import 'package:latlong2/latlong.dart';

class IndoorFloorPlan {
  IndoorFloorPlan({
    required this.buildingId,
    required this.floor,
    required this.outline,
    required this.rooms,
    required this.corridors,
    required this.amenities,
  });

  final String buildingId;
  final int floor;
  final List<LatLng> outline;
  final List<IndoorRoom> rooms;
  final List<IndoorCorridor> corridors;
  final List<IndoorAmenity> amenities;
}

class IndoorRoom {
  IndoorRoom({required this.ref, required this.polygon, this.name, this.type});

  final String ref; 
  final List<LatLng> polygon; 
  final String? name;
  final String? type; 
}

class IndoorCorridor {
  IndoorCorridor({required this.polygon});

  final List<LatLng> polygon;
}

class IndoorAmenity {
  IndoorAmenity({required this.position, required this.type, this.name});

  final LatLng position;
  final String type; 
  final String? name;
}
