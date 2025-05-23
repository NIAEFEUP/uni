import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:uni/model/entities/floor_occupation.dart';

part '../../generated/model/entities/library_occupation.g.dart';

/// Overall occupation of the library
@JsonSerializable()
class LibraryOccupation {
  LibraryOccupation(this.occupation, this.capacity) {
    floors = [];
  }

  factory LibraryOccupation.fromJson(Map<String, dynamic> json) =>
      _$LibraryOccupationFromJson(json);
  late int occupation;
  late int capacity;
  late List<FloorOccupation> floors;

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
    return floors[number - 1];
  }

  void sortFloors() {
    floors.sort((a, b) => a.number.compareTo(b.number));
  }

  Map<String, dynamic> toJson() => _$LibraryOccupationToJson(this);
}
