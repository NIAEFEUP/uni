import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

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
  final icon = UniIcons.starFour;

  final int? locationGroupId;

  @override
  String description(BuildContext context) {
    return '''$roomNumber - $name''';
  }

  @override
  String dedupKey() {
    return 'special_room|$floor|${roomNumber.trim().toLowerCase()}|${name.trim().toLowerCase()}';
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
