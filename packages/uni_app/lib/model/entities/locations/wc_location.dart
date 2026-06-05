import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni_ui/icons.dart';

class WcLocation implements Location {
  WcLocation(this.floor, {this.locationGroupId});
  @override
  final int floor;

  @override
  final weight = 1;

  @override
  final icon = UniIcons.toilet;

  final int? locationGroupId;

  @override
  String description(BuildContext context) {
    return S.of(context).wc;
  }

  @override
  String dedupKey() {
    return 'wc|$floor';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'type': locationTypeToString(LocationType.wc)};
  }
}
