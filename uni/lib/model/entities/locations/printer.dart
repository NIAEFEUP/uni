import 'package:uni/view/locations/widgets/icons.dart';

import 'package:uni/model/entities/location.dart';

class Printer implements Location {
  @override
  final int floor;

  @override
  bool seen = true;

  @override
  final weight = 1;

  @override
  final icon = LocationIcons.printer;

  final int? locationGroupId;

  Printer(this.floor, {this.locationGroupId});

  @override
  String description() {
    return 'Impressora';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {'floor': floor, 'type': locationTypeToString(LocationType.printer)};
  }

  @override
  Location clone() {
    return Printer(floor);
  }
}
