import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class SpecialRoomLocation implements Location{
  final int floor;
  final weight;
  final String roomNumber;
  final String name;
  @override
  final icon = FontAwesomeIcons.solidStar;

  SpecialRoomLocation(this.floor, this.roomNumber, this.name,{this.weight = 0});

  String description(){
    return '''${this.roomNumber} - ${this.name}''';
  }
}