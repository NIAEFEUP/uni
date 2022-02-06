import 'package:flutter_map/flutter_map.dart';
import 'package:collection/collection.dart';
import 'location.dart';

/**
 * Store information about a location marker.
 * What's located in each floor, like vending machines, rooms, etc...
 */
class LocationGroup{
  final Map<int, List<Location>> floors;

  LocationGroup({List<Location> locations = null})
      : this.floors = locations != null
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

}