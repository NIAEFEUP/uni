import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/Widgets/faculty_maps/locations_map.dart';

class FacultyMaps {
  static LocationsMap? getFacultyMap(
      String faculty, List<LocationGroup> locations) {
    switch (faculty) {
      case 'FEUP':
        return getFeupMap(locations);
    }
    return null;
  }

  static LocationsMap getFeupMap(List<LocationGroup> locations) {
    return LocationsMap(
      northEastBoundary: LatLng(41.17986, -8.59298),
      southWestBoundary: LatLng(41.17670, -8.59991),
      center: LatLng(41.17731, -8.59522),
      locations: locations,
    );
  }

  static getFontColor(BuildContext context){
    return  Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onTertiary;
  }
}
