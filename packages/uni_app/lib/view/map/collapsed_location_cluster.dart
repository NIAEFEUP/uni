import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';

class CollapsedLocationCluster {
  CollapsedLocationCluster({
    required this.locationGroup,
    required this.additionalAmenities,
  });

  factory CollapsedLocationCluster.fromGroups(List<LocationGroup> groups) {
    final allLocations = <Location>[];
    var allFloorless = true;
    var latitudeSum = 0.0;
    var longitudeSum = 0.0;

    for (final group in groups) {
      latitudeSum += group.latlng.latitude;
      longitudeSum += group.latlng.longitude;
      allFloorless = allFloorless && group.isFloorless;
      group.floors.values.forEach(allLocations.addAll);
    }

    final deduplicatedLocations = _deduplicateLocations(allLocations);
    final locationTypes = deduplicatedLocations
        .map((location) => location.runtimeType)
        .toSet();
    final totalAmenities = deduplicatedLocations.length;

    return CollapsedLocationCluster(
      locationGroup: LocationGroup(
        LatLng(latitudeSum / groups.length, longitudeSum / groups.length),
        locations: deduplicatedLocations,
        isFloorless: allFloorless,
        id: groups.first.id,
      ),
      additionalAmenities: locationTypes.length > 1 && totalAmenities > 1
          ? totalAmenities - 1
          : 0,
    );
  }

  static List<Location> _deduplicateLocations(List<Location> locations) {
    final seen = <String>{};
    final deduplicated = <Location>[];

    for (final location in locations) {
      final key =
          '${location.floor}|${location.runtimeType}|${location.description().trim().toLowerCase()}';
      if (seen.add(key)) {
        deduplicated.add(location);
      }
    }

    return deduplicated;
  }

  final LocationGroup locationGroup;
  final int additionalAmenities;
}
