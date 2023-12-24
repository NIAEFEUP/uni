import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';

part 'location_group.g.dart';

/// Store information about a location marker.
/// What's located in each floor, like vending machines, rooms, etc...
@JsonSerializable()
class LocationGroup {
  LocationGroup(
    this.latlng, {
    List<Location>? locations,
    this.isFloorless = false,
    this.id,
  }) : floors = locations != null
            ? groupBy(locations, (location) => location.floor)
            : Map.identity();


  factory LocationGroup.fromJson(Map<String, dynamic> json) =>
      _$LocationGroupFromJson(json);
  final Map<int, List<Location>> floors;
  final bool isFloorless;
  final LatLng latlng;
  final int? id;

  /// Returns the Location with the most weight
  Location? getLocationWithMostWeight() {
    final allLocations = floors.values.expand((x) => x).toList();
    return allLocations.reduce(
      (current, next) => current.weight > next.weight ? current : next,
    );
  }

  Map<String, dynamic> toJson() => _$LocationGroupToJson(this);
}
