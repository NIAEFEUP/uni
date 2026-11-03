import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class CoffeeMachine implements Location {
  CoffeeMachine(this.floor, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 3;

  @override
  final icon = UniIcons.coffee;

  final int? locationGroupId;

  @override
  String description(BuildContext context) {
    return S.of(context).coffee_machine;
  }

  @override
  String dedupKey() {
    return 'coffee_machine|$floor';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.coffeeMachine),
    };
  }
}
