import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class RoomGroupLocation implements Location {
  RoomGroupLocation(
    this.floor,
    this.firstRoomNumber,
    this.secondRoomNumber, {
    this.locationGroupId,
  });
  @override
  final int floor;

  @override
  final weight = 0;

  final String firstRoomNumber;
  final String secondRoomNumber;
  @override
  final icon = UniIcons.bookOpenUser;

  final int? locationGroupId;

  @override
  String description(BuildContext context) {
    return '''$firstRoomNumber -> $secondRoomNumber''';
  }

  @override
  String dedupKey() {
    return 'room_group|$floor|${firstRoomNumber.trim().toLowerCase()}|${secondRoomNumber.trim().toLowerCase()}';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.rooms),
      'first_room': firstRoomNumber,
      'last_room': secondRoomNumber,
    };
  }
}
