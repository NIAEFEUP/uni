import 'package:uni/view/Fonts/location_icons.dart';

import 'package:uni/model/entities/location.dart';

class RoomLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 0;

  final String roomNumber;
  @override
  final icon = LocationIcons.bookOpenBlankVariant;

  final int? locationGroupId;

  RoomLocation(this.floor,this.roomNumber, {this.locationGroupId});

  @override
  String description(){
    return roomNumber;
  }

  @override
  Map<String, dynamic> toMap({int? groupId}){
    return {
      'floor' : floor,
      'type' : locationTypeToString(LocationType.room),
      'first_room' : roomNumber
    };
  }
}