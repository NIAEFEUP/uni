import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class RoomLocation implements Location{
  final int floor;
  final weight;
  final String roomNumber;
  @override
  final icon = FontAwesomeIcons.book;

  RoomLocation(this.floor,this.roomNumber, {this.weight = 0});

  String description(){
    return '''${this.roomNumber}''';
  }
}