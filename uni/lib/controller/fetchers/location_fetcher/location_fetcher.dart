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
      final int id = groupMap['id'];
      final double lat = groupMap['lat'];
      final double lng = groupMap['lng'];
      final bool isFloorless = groupMap['isFloorless'];

      final Map<String, dynamic> locationsMap = groupMap['locations'];

      final locations = <Location>[];
      locationsMap.forEach((key, value) {
        final floor = int.parse(key);
        value.forEach((locationJson) {
          locations.add(Location.fromJSON(locationJson, floor));
        });
      });
      groups.add(LocationGroup(LatLng(lat, lng),
          locations: locations, isFloorless: isFloorless, id: id,),);
    }

    return groups;
  }
}
