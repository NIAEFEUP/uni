import 'package:flutter/widgets.dart';

class Bus{
  String busCode;
  String destination;
  bool direction;

  Bus({@required this.busCode, this.destination="", this.direction = false}){}

  Map<String, dynamic> toMap() {
    return {
      'busCode': busCode,
      'destination': destination,
      'direction': direction
    };
  }
}