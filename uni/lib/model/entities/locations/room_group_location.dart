import 'package:uni/model/entities/location.dart';
import 'package:uni/view/locations/widgets/icons.dart';

class RoomGroupLocation implements Location {

  RoomGroupLocation(this.floor, this.firstRoomNumber, this.secondRoomNumber,
      {this.locationGroupId,});
  @override
  final int floor;

  @override
  final weight = 0;

  final String firstRoomNumber;
  final String secondRoomNumber;
  @override
  final icon = LocationIcons.bookOpenBlankVariant;

  final int? locationGroupId;

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
