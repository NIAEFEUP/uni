import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class VendingMachine implements Location {
  VendingMachine(this.floor, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = UniIcons.lockers;

  final int? locationGroupId;

  @override
  String description(BuildContext context) {
    return S.of(context).vending_machine;
  }

  @override
  String dedupKey() {
    return 'vending_machine|$floor';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.vendingMachine),
    };
  }
}
