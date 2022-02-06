import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class RoomLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 0;

  final String roomNumber;
  @override
  final icon = FontAwesomeIcons.book;

  RoomLocation(this.floor,this.roomNumber);

  @override
  String description(){
    return '''${this.roomNumber}''';
  }
}