import 'package:uni/view/Fonts/location_icons.dart';

import 'package:uni/model/entities/location.dart';

class Atm implements Location {
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = LocationIcons.cashMultiple;

  final int? locationGroupId;

  Atm(this.floor, {this.locationGroupId}) : super();

  @override
  String description() {
    return 'Atm';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'type': locationTypeToString(LocationType.atm)};
  }
}
