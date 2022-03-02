import 'package:flutter/material.dart';
import '../location.dart';

class RestaurantLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 4;

  final name;

  @override
  final icon = Icons.restaurant;

  RestaurantLocation(this.floor,this.name);

  @override
  String description(){
    return this.name;
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : this.floor,
      'type' : locationTypeToString(LocationType.restaurant),
      'name' : this.name
    };
  }
}