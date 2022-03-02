import 'package:collection/collection.dart';
import 'package:latlong2/latlong.dart';
import 'location.dart';

/**
 * Store information about a location marker.
 * What's located in each floor, like vending machines, rooms, etc...
 */
class LocationGroup{
  final Map<int, List<Location>> floors;
  final bool isFloorless;
  final LatLng latlng;
  final id;
  LocationGroup(this.latlng,
        {
          List<Location> locations = null,
          this.isFloorless = false,
          this.id = null
        }
  ) : this.floors = locations != null
    ? groupBy(locations, (location) => location.floor)
    : Map.identity(){}

  /**
   * Returns the Location with the most weight
   */
  Location getFirst(){
          final List<Location> allLocations =
            floors.values.expand((x) => x).toList();
          if(allLocations == null) return null;
          //Get Location with most weight
          return allLocations.reduce((current, next ) =>
                current.weight > next.weight ? current: next);
  }

  Map<String, dynamic> toMap(){
    return {
      'id' : this.id,
      'lat' : latlng.latitude,
      'lng' : latlng.longitude,
      'is_floorless' : isFloorless
    };
  }

}