import 'package:uni/model/entities/location.dart';
import 'package:uni/view/locations/widgets/icons.dart';

class RoomLocation implements Location {
  RoomLocation(this.floor, this.roomNumber, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 0;

  final String roomNumber;
  @override
  final icon = LocationIcons.bookOpenBlankVariant;

  final int? locationGroupId;

  @override
  String description() {
    return roomNumber;
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.room),
      'first_room': roomNumber,
    };
  }
}
