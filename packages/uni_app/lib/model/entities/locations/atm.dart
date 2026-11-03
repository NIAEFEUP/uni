import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class Atm implements Location {
  Atm(this.floor, {this.locationGroupId}) : super();
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = UniIcons.money;

  final int? locationGroupId;

  @override
  String description(BuildContext context) {
    return S.of(context).atm;
  }

  @override
  String dedupKey() {
    return 'atm|$floor';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'type': locationTypeToString(LocationType.atm)};
  }
}
