import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';

class StoreLocation implements Location {
  StoreLocation(this.floor, this.name, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 4;

  final String name;
  @override
  final icon = Icons.store;

  final int? locationGroupId;

  @override
  String description() {
    return name;
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.store),
      'name': name,
    };
  }
}
