import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';

class SpecialRoomLocation implements Location {
  SpecialRoomLocation(
    this.floor,
    this.roomNumber,
    this.name, {
    this.locationGroupId,
  });
  @override
  final int floor;

  @override
  final weight = 1;

  final String roomNumber;
  final String name;
  @override
  final icon = Icons.star;

  final int? locationGroupId;

  @override
  String description() {
    return '''$roomNumber - $name''';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.printer),
      'first_room': roomNumber,
      'name': name,
    };
  }
}
