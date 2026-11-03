import 'package:uni/model/entities/indoor_floor_plan.dart';

class OSMElement {
  OSMElement({
    required this.id,
    required this.type,
    required this.tags,
    this.lat,
    this.lon,
    this.nodes,
  });

  factory OSMElement.fromJson(Map<String, dynamic> json) {
    return OSMElement(
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

class FloorData {
  FloorData({
    required this.rooms,
    required this.corridors,
    required this.amenities,
  });

  final List<IndoorRoom> rooms;
  final List<IndoorCorridor> corridors;
  final List<IndoorAmenity> amenities;
}
