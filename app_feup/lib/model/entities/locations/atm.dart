import 'package:flutter/cupertino.dart';
import '../location.dart';

class Atm implements Location{
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = 'assets/images/cash_multiple.svg';

  Atm(this.floor) : super();

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