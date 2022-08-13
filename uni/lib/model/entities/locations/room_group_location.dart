import 'package:uni/view/Fonts/location_icons.dart';

import 'package:uni/model/entities/location.dart';

class RoomGroupLocation implements Location {
  @override
  final int floor;

  @override
  final weight = 0;

  final String firstRoomNumber;
  final String secondRoomNumber;
  @override
  final icon = LocationIcons.bookOpenBlankVariant;

  final int? locationGroupId;

  RoomGroupLocation(this.floor, this.firstRoomNumber, this.secondRoomNumber,
      {this.locationGroupId});

  @override
  String description() {
    return '''$firstRoomNumber -> $secondRoomNumber''';
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
