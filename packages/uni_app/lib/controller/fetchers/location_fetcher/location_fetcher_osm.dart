import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/entities/locations/atm.dart';
import 'package:uni/model/entities/locations/coffee_machine.dart';
import 'package:uni/model/entities/locations/printer.dart';
import 'package:uni/model/entities/locations/restaurant_location.dart';
import 'package:uni/model/entities/locations/room_location.dart';
import 'package:uni/model/entities/locations/special_room_location.dart';
import 'package:uni/model/entities/locations/vending_machine.dart';
import 'package:uni/model/entities/locations/wc_location.dart';

class LocationFetcherOSM extends LocationFetcher {
  static const double minLat = 41.176;
  static const double maxLat = 41.179;
  static const double minLon = -8.598;
  static const double maxLon = -8.594;

  @override
  Future<List<LocationGroup>> getLocations() async {
    try {
      final response = await getData();
      return _parseOSMResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch from OSM: $e');
    }
  }

  Future<List<IndoorFloorPlan>> getIndoorFloorPlans() async {
    try {
      final response = await getData();
      return _parseIndoorData(response);
    } catch (e) {
      throw Exception('Failed to fetch indoor data: $e');
    }
  }

  Future<http.Response> getData() async {
    debugPrint('⬇️  Fetching OSM data from Overpass API...');
    final response = await _queryOverpass();
    debugPrint(
      '✓ OSM data fetched successfully (${response.body.length} bytes)',
    );
    return response;
  }

  Future<http.Response> _queryOverpass() async {
    const overpassUrl = 'https://overpass-api.de/api/interpreter';

    const query = '''
      [out:json][timeout:25];
      (
        // Get FEUP buildings
        way["building"]["name"~"FEUP|Faculdade de Engenharia"]($minLat,$minLon,$maxLat,$maxLon);
        
        // Get indoor features (rooms, corridors, areas)
        node["indoor"]($minLat,$minLon,$maxLat,$maxLon);
        way["indoor"]($minLat,$minLon,$maxLat,$maxLon);
        
        // Get amenities
        node["amenity"]($minLat,$minLon,$maxLat,$maxLon);
        way["amenity"]($minLat,$minLon,$maxLat,$maxLon);
      );
      out body;
      >;
      out skel qt;
    ''';

    final response = await http.post(
      Uri.parse(overpassUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: 'data=$query',
    );

    if (response.statusCode != 200) {
      throw Exception('Overpass API returned ${response.statusCode}');
    }

    debugPrint('OSM query returned ${response.body.length} bytes');
    return response;
  }

  List<IndoorFloorPlan> _parseIndoorData(http.Response response) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = json['elements'] as List<dynamic>;

    debugPrint(
      '📍 Parsing indoor data for ALL buildings from ${elements.length} elements',
    );

    // Build node map ONCE for all buildings
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
    debugPrint('   Built node map with ${nodeMap.length} nodes');

    // Map: BuildingCode -> Floor -> FloorData
    final buildingFloorMap = <String, Map<int, _FloorData>>{};

    for (final elem in elements) {
      final element = _OSMElement.fromJson(elem as Map<String, dynamic>);

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
        () => _FloorData(rooms: [], corridors: [], amenities: []),
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
      } else if (element.type == 'node' &&
          element.lat != null &&
          element.lon != null) {
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
      debugPrint(
        'Building $buildingCode has ${buildingEntry.value.length} floors',
      );

      for (final floorEntry in buildingEntry.value.entries) {
        final floor = floorEntry.key;
        final data = floorEntry.value;

        debugPrint(
          '  Floor $floor: ${data.rooms.length} rooms, '
          '${data.corridors.length} corridors, ${data.amenities.length} amenities',
        );

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

    debugPrint(
      '✅ Total: ${allPlans.length} floor plans from ${buildingFloorMap.length} buildings',
    );
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

  Future<List<LocationGroup>> _parseOSMResponse(http.Response response) async {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = json['elements'] as List<dynamic>;

    debugPrint('Parsing ${elements.length} OSM elements for location groups');

    final Map<String, List<_OSMElement>> buildingGroups = {};

    for (final elem in elements) {
      final element = _OSMElement.fromJson(elem as Map<String, dynamic>);
      final buildingCode = _extractBuildingCode(element);

      if (buildingCode != null) {
        buildingGroups.putIfAbsent(buildingCode, () => []);
        buildingGroups[buildingCode]!.add(element);
      }
    }

    final locationGroups = <LocationGroup>[];
    var groupId = 0;

    for (final entry in buildingGroups.entries) {
      final elements = entry.value;
      final center = _calculateCenter(elements);
      final locations = _convertToLocations(elements);

      if (locations.isNotEmpty) {
        locationGroups.add(
          LocationGroup(
            center,
            locations: locations,
            isFloorless: !_hasFloorData(elements),
            id: groupId++,
          ),
        );
      }
    }

    debugPrint('Created ${locationGroups.length} location groups');
    return locationGroups;
  }

  String? _extractBuildingCode(_OSMElement element) {
    final ref =
        element.tags['ref'] ??
        element.tags['addr:unit'] ??
        element.tags['name'];

    if (ref != null) {
      final match = RegExp('^([A-Z])').firstMatch(ref);
      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }

  LatLng _calculateCenter(List<_OSMElement> elements) {
    var sumLat = 0.0;
    var sumLon = 0.0;
    var count = 0;

    for (final element in elements) {
      if (element.lat != null && element.lon != null) {
        sumLat += element.lat!;
        sumLon += element.lon!;
        count++;
      }
    }

    if (count == 0) {
      return const LatLng(41.1775, -8.596);
    }

    return LatLng(sumLat / count, sumLon / count);
  }

  List<Location> _convertToLocations(List<_OSMElement> elements) {
    final locations = <Location>[];

    for (final element in elements) {
      final floor = _extractFloor(element);
      final location = _createLocation(element, floor);

      if (location != null) {
        locations.add(location);
      }
    }

    return locations;
  }

  int _extractFloor(_OSMElement element) {
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

  Location? _createLocation(_OSMElement element, int floor) {
    final tags = element.tags;

    if (tags['amenity'] == 'vending_machine') {
      if (tags['vending'] == 'coffee') {
        return CoffeeMachine(floor);
      }
      return VendingMachine(floor);
    }

    if (tags['amenity'] == 'cafe' || tags['amenity'] == 'restaurant') {
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

    if (tags['indoor'] == 'room') {
      final ref = tags['ref'] ?? tags['name'];
      if (ref != null) {
        final description = tags['description'] ?? tags['office'];

        if (description != null && description.isNotEmpty) {
          return SpecialRoomLocation(floor, ref, description);
        }

        return RoomLocation(floor, ref);
      }
    }

    return null;
  }

  bool _hasFloorData(List<_OSMElement> elements) {
    return elements.any(
      (e) =>
          e.tags['level'] != null ||
          e.tags['floor'] != null ||
          e.tags['building:levels'] != null,
    );
  }
}

class _OSMElement {
  _OSMElement({
    required this.id,
    required this.type,
    required this.tags,
    this.lat,
    this.lon,
    this.nodes,
  });

  factory _OSMElement.fromJson(Map<String, dynamic> json) {
    return _OSMElement(
      id: json['id'] as int,
      type: json['type'] as String,
      tags: Map<String, String>.from(
        (json['tags'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, value.toString()),
            ) ??
            {},
      ),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      nodes: (json['nodes'] as List<dynamic>?)?.cast<int>(),
    );
  }

  final int id;
  final String type;
  final Map<String, String> tags;
  final double? lat;
  final double? lon;
  final List<int>? nodes;
}

class _FloorData {
  _FloorData({
    required this.rooms,
    required this.corridors,
    required this.amenities,
  });

  final List<IndoorRoom> rooms;
  final List<IndoorCorridor> corridors;
  final List<IndoorAmenity> amenities;
}
