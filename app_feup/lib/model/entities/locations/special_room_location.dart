import 'package:flutter/material.dart';

import '../location.dart';

class SpecialRoomLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 1;

  final String roomNumber;
  final String name;
  @override
  final icon = Icons.star;

  SpecialRoomLocation(this.floor, this.roomNumber, this.name);

  @override
  String description(){
    return '''${this.roomNumber} - ${this.name}''';
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : this.floor,
      'type' : locationTypeToString(LocationType.printer),
      'first_room' : this.roomNumber,
      'name' : this.name
    };
  }
}