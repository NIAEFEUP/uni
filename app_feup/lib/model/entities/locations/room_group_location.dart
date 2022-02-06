import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class RoomGroupLocation implements Location{
  final int floor;
  final weight;
  final String firstRoomNumber;
  final String secondRoomNumber;
  @override
  final icon = FontAwesomeIcons.book;

  RoomGroupLocation(this.floor,this.firstRoomNumber, this.secondRoomNumber, {this.weight = 0});

  String description(){
    return '''${this.firstRoomNumber} -> ${this.secondRoomNumber}''';
  }
}