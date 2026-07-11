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
  static const double _amenityCollapseDistanceMeters = 5;

  static List<Location> _deduplicateLocations(List<Location> locations) {
    final seen = <String>{};
    final deduplicated = <Location>[];

    for (final location in locations) {
      final key = location.dedupKey();
      if (seen.add(key)) {
        deduplicated.add(location);
      }
    }

    return deduplicated;
  }

  static List<CollapsedLocationCluster> collapseNearbyAmenities(
    List<LocationGroup> groups,
  ) {
    if (groups.isEmpty) {
      return <CollapsedLocationCluster>[];
    }

    final visited = List<bool>.filled(groups.length, false);
    final clusters = <CollapsedLocationCluster>[];
    const distance = Distance();

    for (var index = 0; index < groups.length; index++) {
      if (visited[index]) {
        continue;
      }

      final pending = <int>[index];
      final clusterIndexes = <int>[];

      while (pending.isNotEmpty) {
        final currentIndex = pending.removeLast();
        if (visited[currentIndex]) {
          continue;
        }

        visited[currentIndex] = true;
        clusterIndexes.add(currentIndex);

        for (var otherIndex = 0; otherIndex < groups.length; otherIndex++) {
          if (visited[otherIndex] || currentIndex == otherIndex) {
            continue;
          }

          final meters = distance.as(
            LengthUnit.Meter,
            groups[currentIndex].latlng,
            groups[otherIndex].latlng,
          );

          if (meters <= _amenityCollapseDistanceMeters) {
            pending.add(otherIndex);
          }
        }
      }

      final clusterGroups = clusterIndexes
          .map((clusterIndex) => groups[clusterIndex])
          .toList();
      clusters.add(CollapsedLocationCluster.fromGroups(clusterGroups));
    }
    return clusters;
  }

  final LocationGroup locationGroup;
  final int additionalAmenities;
}
