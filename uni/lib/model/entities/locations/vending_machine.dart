import 'package:uni/view/locations/widgets/icons.dart';

import 'package:uni/model/entities/location.dart';

class VendingMachine implements Location {
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = LocationIcons.bottleSodaClassic;

  final int? locationGroupId;

  VendingMachine(this.floor, {this.locationGroupId});

  @override
  String description() {
    return 'Máquina de venda';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.vendingMachine)
    };
  }
}
