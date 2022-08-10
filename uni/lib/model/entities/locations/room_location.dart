import 'package:uni/view/Fonts/location_icons.dart';

import '../location.dart';

class RoomLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 0;

  final String roomNumber;
  @override
  final icon = LocationIcons.bookOpenBlankVariant;

  final int locationGroupId;

  RoomLocation(this.floor,this.roomNumber, {this.locationGroupId = null});

  @override
  String description(){
    return '''${this.roomNumber}''';
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : this.floor,
      'type' : locationTypeToString(LocationType.room),
      'first_room' : this.roomNumber
    };
  }
}