import 'dart:math';
import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part '../../generated/model/entities/library_occupation.g.dart';

/// Overall occupation of the library
@JsonSerializable()
class LibraryOccupation {
  LibraryOccupation(this.occupation, this.capacity) {
    floors = SplayTreeSet<FloorOccupation>((a, b) => a.number.compareTo(b.number));
  }

  factory LibraryOccupation.fromJson(Map<String, dynamic> json) =>
      _$LibraryOccupationFromJson(json);
  late int occupation;
  late int capacity;
  
  @JsonKey(fromJson: _floorsFromJson, toJson: _floorsToJson)
  late SplayTreeSet<FloorOccupation> floors;

  void addFloor(FloorOccupation floor) {
    floors.add(floor);
    occupation += floor.occupation;
    capacity += floor.capacity;
  }

  int get percentage {
    if (capacity <= 0) {
      return 0;
    }
    return min(100, (occupation * 100 / capacity).round());
  }

  FloorOccupation getFloor(int number) {
    if (floors.length < number || number < 0) {
      return FloorOccupation(0, 0, 0);
    }
    return floors.elementAt(number - 1);
  }

  Map<String, dynamic> toJson() => _$LibraryOccupationToJson(this);

  static SplayTreeSet<FloorOccupation> _floorsFromJson(List<dynamic> json) {
    var set = SplayTreeSet<FloorOccupation>((a, b) => a.number.compareTo(b.number));
    json.forEach((element) {
      set.add(FloorOccupation.fromJson(element as Map<String, dynamic>));
    });
    return set;
  }

  static List<Map<String, dynamic>> _floorsToJson(SplayTreeSet<FloorOccupation> floors) {
    return floors.map((floor) => floor.toJson()).toList();
  }
}

/// Occupation values of a single floor
@JsonSerializable()
class FloorOccupation {
  FloorOccupation(this.number, this.occupation, this.capacity);

  factory FloorOccupation.fromJson(Map<String, dynamic> json) =>
      _$FloorOccupationFromJson(json);
  final int number;
  final int occupation;
  final int capacity;

  int get percentage {
    if (capacity <= 0) {
      return 0;
    }
    return min(100, (occupation * 100 / capacity).round());
  }

  Map<String, dynamic> toJson() => _$FloorOccupationToJson(this);
}