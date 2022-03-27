import '../location.dart';

class RoomGroupLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 0;

  final String firstRoomNumber;
  final String secondRoomNumber;
  @override
  final icon = 'assets/images/book_open_blank_variant.svg';

  RoomGroupLocation(this.floor,this.firstRoomNumber, this.secondRoomNumber);

  @override
  String description(){
    return '''${this.firstRoomNumber} -> ${this.secondRoomNumber}''';
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : floor,
      'type' : locationTypeToString(LocationType.rooms),
      'first_room' : this.firstRoomNumber,
      'last_room' : this.secondRoomNumber,
    };
  }
}