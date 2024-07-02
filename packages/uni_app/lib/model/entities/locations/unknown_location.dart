import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';

class UnknownLocation implements Location {
  UnknownLocation(this.floor, this.type, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 4;

  @override
  final icon = Icons.store;

  final int? locationGroupId;

  final String type;

  @override
  String description() {
    return type;
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': type,
    };
  }
}
