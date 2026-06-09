import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class CarPark implements Location {
  CarPark(this.floor, this.name, {this.locationGroupId});
  @override
  final int floor;
  final String name;

  @override
  final weight = 1;

  @override
  final icon = UniIcons.carPark;

  final int? locationGroupId;

  @override
  String description(BuildContext context) {
    if (name.toLowerCase() == 'parking') {
      return S.of(context).parking;
    }
    return name;
  }

  @override
  String dedupKey() {
    return 'car_park|$floor|${name.trim().toLowerCase()}';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'name': name,
      'type': locationTypeToString(LocationType.carPark),
    };
  }
}
