import 'package:collection/collection.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';

/// Store information about a location marker.
/// What's located in each floor, like vending machines, rooms, etc...
class LocationGroup {
  final Map<int, List<Location>> floors;
  final bool isFloorless;
  final LatLng latlng;
  final int? id;

  LocationGroup(this.latlng,
      {List<Location>? locations, this.isFloorless = false, this.id})
      : floors = locations != null
            ? groupBy(locations, (location) => location.floor)
            : Map.identity();

  LocationGroup.fromFloors(this.latlng, this.floors, this.isFloorless, this.id);

  /// Returns the Location with the most weight
  Location? getLocationWithMostWeight() {
    final List<Location> allLocations = floors.values.expand((x) => x).toList();
    return allLocations.reduce(
        (current, next) => current.weight > next.weight ? current : next);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': latlng.latitude,
      'lng': latlng.longitude,
      'is_floorless': isFloorless ? 1 : 0,
    };
  }

  LocationGroup clone() {
    return LocationGroup.fromFloors(latlng, Map.from(floors), isFloorless, id);
  }

  /**
  Map<String, dynamic> toJson() => {
        'latlng': latlng,
        'floors': floors,
        'isFloorless': isFloorless,
        'id': id
      };

  static LocationGroup fromJson(Map<String, dynamic> json) =>
      LocationGroup.fromFloors(
          json['latlng'] as LatLng,
          json['floors'] as Map<int, List<Location>>,
          json['isFloorless'] as bool,
          json['id'] as int);
      **/
}
