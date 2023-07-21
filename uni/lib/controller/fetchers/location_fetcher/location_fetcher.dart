import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';

abstract class LocationFetcher {
  Future<List<LocationGroup>> getLocations();

  Future<List<LocationGroup>> getFromJSON(String jsonStr) async {
    final Map<String, dynamic> json = jsonDecode(jsonStr);
    final List<dynamic> groupsMap = json['data'];
    final groups = <LocationGroup>[];

    for (final Map<String, dynamic> groupMap in groupsMap) {
      final id = groupMap['id'] as int;
      final lat = groupMap['lat'] as double;
      final lng = groupMap['lng'] as double;
      final isFloorless = groupMap['isFloorless'] as bool;

      final Map<String, dynamic> locationsMap = groupMap['locations'];

      final locations = <Location>[];
      locationsMap.forEach((key, value) {
        final floor = int.parse(key);
        value.forEach((locationJson) {
          locations.add(Location.fromJSON(locationJson, floor));
        });
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
