import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';

class WcLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 1;

  @override
  final icon = Icons.wc;

  final int? locationGroupId;

  WcLocation(this.floor, {this.locationGroupId});

  @override
  String description(){
    return 'Atm';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}){
    return {
      'floor' : floor,
      'type' : locationTypeToString(LocationType.atm)
    };
  }

}