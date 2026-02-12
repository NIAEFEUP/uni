import 'package:latlong2/latlong.dart';

/// Represents an indoor floor plan with its geometry and features
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
  final List<LatLng> outline; // Building outline for this floor
  final List<IndoorRoom> rooms;
  final List<IndoorCorridor> corridors;
  final List<IndoorAmenity> amenities;
}

class IndoorRoom {
  IndoorRoom({required this.ref, required this.polygon, this.name, this.type});

  final String ref; // Room number (e.g., "B101")
  final List<LatLng> polygon; // Room outline
  final String? name;
  final String? type; // office, classroom, lab, etc.
}

class IndoorCorridor {
  IndoorCorridor({required this.polygon});

  final List<LatLng> polygon;
}

class IndoorAmenity {
  IndoorAmenity({required this.position, required this.type, this.name});

  final LatLng position;
  final String type; // toilets, vending_machine, etc.
  final String? name;
}
