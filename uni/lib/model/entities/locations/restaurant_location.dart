import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';

class RestaurantLocation implements Location {
  @override
  final int floor;

  @override
  final int weight = 4;

  final String name;

  @override
  final icon = Icons.restaurant;

  final int? locationGroupId;

  RestaurantLocation(this.floor, this.name, {this.locationGroupId});

  @override
  String description() {
    return name;
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.restaurant),
      'name': name
    };
  }
}
