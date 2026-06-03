import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class RestaurantLocation implements Location {
  RestaurantLocation(this.floor, this.name, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 4;

  final String name;

  @override
  final icon = UniIcons.restaurant;

  final int? locationGroupId;

  @override
  String description(BuildContext context) {
    return name;
  }

  @override
  String dedupKey() {
    return 'restaurant|$floor|${name.trim().toLowerCase()}';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.restaurant),
      'name': name,
    };
  }
}
