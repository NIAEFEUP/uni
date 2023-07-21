import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';

abstract class LocationFetcher {
  Future<List<LocationGroup>> getLocations();

  Future<List<LocationGroup>> getFromJSON(String jsonStr) async {
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    final groupsMap = json['data'] as List<dynamic>;
    final groups = <LocationGroup>[];

    for (final groupMap in groupsMap) {
      final map = groupMap as Map<String, dynamic>;
      final id = map['id'] as int;
      final lat = map['lat'] as double;
      final lng = map['lng'] as double;
      final isFloorless = map['isFloorless'] as bool;

      final locationsMap = map['locations'] as Map<String, dynamic>;

      final locations = <Location>[];
      locationsMap.forEach((key, value) {
        final floor = int.parse(key);
        for (final locationJson in value as List) {
          locations.add(
            Location.fromJSON(locationJson as Map<String, dynamic>, floor),
          );
        }
      });
      groups.add(
        LocationGroup(
          LatLng(lat, lng),
          locations: locations,
          isFloorless: isFloorless,
          id: id,
        ),
      );
    }

    return groups;
  }
}
