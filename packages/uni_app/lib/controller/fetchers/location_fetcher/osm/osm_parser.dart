import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/fetchers/location_fetcher/osm/osm_models.dart';
import 'package:uni/model/entities/faculty_config.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/entities/locations/atm.dart';
import 'package:uni/model/entities/locations/coffee_machine.dart';
import 'package:uni/model/entities/locations/parking.dart';
import 'package:uni/model/entities/locations/printer.dart';
import 'package:uni/model/entities/locations/restaurant_location.dart';
import 'package:uni/model/entities/locations/store_location.dart';
import 'package:uni/model/entities/locations/vending_machine.dart';
import 'package:uni/model/entities/locations/wc_location.dart';

class OSMParser {
  OSMParser(this.facultyConfig);

  final FacultyConfig facultyConfig;

  List<IndoorFloorPlan> parseIndoorData(http.Response response) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = json['elements'] as List<dynamic>;

    final nodeMap = <int, LatLng>{};
    for (final elem in elements) {
      final element = elem as Map<String, dynamic>;
      if (element['type'] == 'node') {
        final id = element['id'] as int;
        final lat = (element['lat'] as num?)?.toDouble();
        final lon = (element['lon'] as num?)?.toDouble();
        if (lat != null && lon != null) {
          nodeMap[id] = LatLng(lat, lon);
        }
      }
    }

    // Map: BuildingCode -> Floor -> FloorData
    final buildingFloorMap = <String, Map<int, FloorData>>{};

    for (final elem in elements) {
      final element = OSMElement.fromJson(elem as Map<String, dynamic>);

      final isAmenity =
          element.tags['amenity'] != null &&
          (element.lat != null && element.lon != null ||
              element.nodes != null && element.nodes!.isNotEmpty);

      if (isAmenity) {
        final buildingCode = _extractBuildingCode(element) ?? 'NO_BUILDING';
        final floor = _extractFloor(element);

        LatLng? position;
        if (element.lat != null && element.lon != null) {
          position = LatLng(element.lat!, element.lon!);
        } else if (element.nodes != null && element.nodes!.isNotEmpty) {
          // Calculate centroid from node positions
          final nodePositions = element.nodes!
              .map((id) => nodeMap[id])
              .where((pos) => pos != null)
              .cast<LatLng>()
              .toList();
          if (nodePositions.isNotEmpty) {
            final avgLat =
                nodePositions.map((p) => p.latitude).reduce((a, b) => a + b) /
                nodePositions.length;
            final avgLon =
                nodePositions.map((p) => p.longitude).reduce((a, b) => a + b) /
                nodePositions.length;
            position = LatLng(avgLat, avgLon);
          }
        }

        if (position != null) {
          buildingFloorMap.putIfAbsent(buildingCode, () => {});
          buildingFloorMap[buildingCode]!.putIfAbsent(
            floor,
            () => FloorData(rooms: [], corridors: [], amenities: []),
          );

          buildingFloorMap[buildingCode]![floor]!.amenities.add(
            IndoorAmenity(
              position: position,
              type: element.tags['amenity']!,
              name: element.tags['name'],
            ),
          );
        }
        continue;
      }

      // Extract building code from ref
      final ref = element.tags['ref'] ?? '';
      if (ref.isEmpty) {
        continue;
      }

      final buildingCode = _extractBuildingCode(element);
      if (buildingCode == null) {
        continue;
      }

      final floor = _extractFloor(element);

      // Initialize building and floor if needed
      buildingFloorMap.putIfAbsent(buildingCode, () => {});
      buildingFloorMap[buildingCode]!.putIfAbsent(
        floor,
        () => FloorData(rooms: [], corridors: [], amenities: []),
      );

      // Parse features
      if (element.type == 'way' && element.nodes != null) {
        final polygon = _buildPolygonFromNodeMap(element.nodes!, nodeMap);
        if (polygon.isEmpty) {
          continue;
        }

        final indoorType = element.tags['indoor'];

        if (indoorType == 'room') {
          final roomRef =
              element.tags['ref'] ??
              element.tags['name'] ??
              'Room ${element.id}';
          buildingFloorMap[buildingCode]![floor]!.rooms.add(
            IndoorRoom(
              ref: roomRef,
              polygon: polygon,
              name: element.tags['name'],
              type:
                  element.tags['room'] ??
                  element.tags['office'] ??
                  element.tags['amenity'],
            ),
          );
        } else if (indoorType == 'corridor' || indoorType == 'area') {
          buildingFloorMap[buildingCode]![floor]!.corridors.add(
            IndoorCorridor(polygon: polygon),
          );
        }
      } else if (element.type == 'node' ||
          element.type == 'way' && element.lat != null && element.lon != null) {
        final amenityType = element.tags['amenity'];
        if (amenityType != null) {
          buildingFloorMap[buildingCode]![floor]!.amenities.add(
            IndoorAmenity(
              position: LatLng(element.lat!, element.lon!),
              type: amenityType,
              name: element.tags['name'],
            ),
          );
        }
      }
    }

    // Convert to flat list of IndoorFloorPlan
    final allPlans = <IndoorFloorPlan>[];
    for (final buildingEntry in buildingFloorMap.entries) {
      final buildingCode = buildingEntry.key;

      for (final floorEntry in buildingEntry.value.entries) {
        final floor = floorEntry.key;
        final data = floorEntry.value;

        allPlans.add(
          IndoorFloorPlan(
            buildingId: buildingCode,
            floor: floor,
            outline: [],
            rooms: data.rooms,
            corridors: data.corridors,
            amenities: data.amenities,
          ),
        );
      }
    }

    return allPlans;
  }

  /// Build polygon from node IDs using pre-built node map (performance optimization)
  List<LatLng> _buildPolygonFromNodeMap(
    List<int> nodeIds,
    Map<int, LatLng> nodeMap,
  ) {
    final polygon = <LatLng>[];

    // Build polygon from node IDs
    for (final nodeId in nodeIds) {
      if (nodeMap.containsKey(nodeId)) {
        polygon.add(nodeMap[nodeId]!);
      }
    }

    return polygon;
  }

  List<LocationGroup> parseLocations(http.Response response) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = json['elements'] as List<dynamic>;

    // Build node map so way centroids can be computed.
    final nodeMap = <int, LatLng>{};
    final allElements = <OSMElement>[];
    for (final elem in elements) {
      final element = OSMElement.fromJson(elem as Map<String, dynamic>);
      allElements.add(element);
      if (element.type == 'node' &&
          element.lat != null &&
          element.lon != null) {
        nodeMap[element.id] = LatLng(element.lat!, element.lon!);
      }
    }

    final locationGroups = <LocationGroup>[];

    for (final element in allElements) {
      final amenityType = element.tags['amenity'];
      if (amenityType == null) {
        continue; // rooms / buildings handled by indoor layer
      }

      final position = _resolvePosition(element, nodeMap);
      if (position == null) {
        continue;
      }

      final floor = _extractFloor(element);
      if (_shouldSkipLocationMarker(element, floor)) {
        continue;
      }
      final location = _createLocation(element, floor);
      if (location == null) {
        continue;
      }

      final isFloorless =
          element.tags['level'] == null && element.tags['floor'] == null;

      locationGroups.add(
        LocationGroup(
          position,
          locations: [location],
          isFloorless: isFloorless,
          id: locationGroups.length,
        ),
      );
    }
    return locationGroups;
  }

  bool _shouldSkipLocationMarker(OSMElement element, int floor) {
    // Library only have toilets in -1
    if (facultyConfig.id != 'feup' || element.tags['amenity'] != 'toilets') {
      return false;
    }

    if (floor < 0 || floor > 6) {
      return false;
    }

    return _extractBuildingCode(element) == 'C';
  }

  // For nodes: the direct lat/lon.  For ways: the centroid of their nodes.
  LatLng? _resolvePosition(OSMElement element, Map<int, LatLng> nodeMap) {
    if (element.lat != null && element.lon != null) {
      return LatLng(element.lat!, element.lon!);
    }
    if (element.nodes != null && element.nodes!.isNotEmpty) {
      final pts = element.nodes!
          .map((id) => nodeMap[id])
          .whereType<LatLng>()
          .toList();
      if (pts.isEmpty) {
        return null;
      }
      return _centroidOf(pts);
    }
    return null;
  }

  LatLng _centroidOf(List<LatLng> positions) {
    final avgLat =
        positions.map((p) => p.latitude).reduce((a, b) => a + b) /
        positions.length;
    final avgLon =
        positions.map((p) => p.longitude).reduce((a, b) => a + b) /
        positions.length;
    return LatLng(avgLat, avgLon);
  }

  String? _extractBuildingCode(OSMElement element) {
    final ref =
        element.tags['ref'] ??
        element.tags['addr:unit'] ??
        element.tags['name'];

    if (ref != null) {
      final match = facultyConfig.buildingCodePattern.firstMatch(ref);
      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }

  int _extractFloor(OSMElement element) {
    final level =
        element.tags['level'] ??
        element.tags['floor'] ??
        element.tags['building:levels'];

    if (level != null) {
      final parts = level.split(';');
      final firstLevel = int.tryParse(parts.first.trim());
      if (firstLevel != null) {
        return firstLevel;
      }
    }

    final ref = element.tags['ref'];
    if (ref != null && ref.length >= 2) {
      final floorDigit = ref[1];
      final floor = int.tryParse(floorDigit);
      if (floor != null) {
        return floor;
      }
    }

    return 0;
  }

  Location? _createLocation(OSMElement element, int floor) {
    final tags = element.tags;

    if (tags['amenity'] == 'vending_machine') {
      if (tags['vending'] == 'coffee') {
        return CoffeeMachine(floor);
      }
      return VendingMachine(floor);
    }

    if (tags['amenity'] == 'cafe' ||
        tags['amenity'] == 'restaurant' ||
        tags['amenity'] == 'canteen' ||
        tags['amenity'] == 'fast_food') {
      final name = tags['name'] ?? 'Café';
      return RestaurantLocation(floor, name);
    }

    if (tags['amenity'] == 'toilets') {
      return WcLocation(floor);
    }

    if (tags['amenity'] == 'atm') {
      return Atm(floor);
    }

    if (tags['amenity'] == 'printer') {
      return Printer(floor);
    }

    if (tags['amenity'] == 'parking') {
      final name = tags['name'] ?? 'parking';
      return CarPark(floor, name);
    }

    if (tags['amenity'] == 'shop') {
      final name = tags['name'] ?? 'shop';
      return StoreLocation(floor, name);
    }

    return null;
  }
}
