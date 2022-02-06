import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class RoomGroupLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 0;

  final String firstRoomNumber;
  final String secondRoomNumber;
  @override
  final icon = FontAwesomeIcons.book;

  RoomGroupLocation(this.floor,this.firstRoomNumber, this.secondRoomNumber);

  @override
  String description(){
    return '''${this.firstRoomNumber} -> ${this.secondRoomNumber}''';
  }
}