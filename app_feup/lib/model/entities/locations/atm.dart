import 'package:flutter/cupertino.dart';
import '../location.dart';

class Atm implements Location{
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = CupertinoIcons.creditcard;

  Atm(this.floor);

  @override
  String description(){
    return 'Atm';
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : floor,
      'type' : locationTypeToString(LocationType.atm)
    };
  }

}