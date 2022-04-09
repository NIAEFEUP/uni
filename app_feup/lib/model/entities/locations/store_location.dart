import 'package:flutter/material.dart';

import '../location.dart';

class StoreLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 4;

  final String name;
  @override
  final icon = Icons.store;

  final int locationGroupId;

  StoreLocation(this.floor,this.name, {this.locationGroupId = null});

  @override
  String description(){
    return name;
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : this.floor,
      'type' : locationTypeToString(LocationType.store),
      'name' : this.name
    };
  }
}