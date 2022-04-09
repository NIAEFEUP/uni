import 'package:flutter/material.dart';
import '../location.dart';

class WcLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 1;

  @override
  final icon = Icons.wc;

  final int locationGroupId;

  WcLocation(this.floor, {this.locationGroupId = null});

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