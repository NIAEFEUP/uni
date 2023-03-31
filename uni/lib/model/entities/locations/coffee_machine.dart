import 'package:uni/view/locations/widgets/icons.dart';

import 'package:uni/model/entities/location.dart';

class CoffeeMachine implements Location {
  @override
  final int floor;

  @override
  final weight = 3;

  @override
  final icon = LocationIcons.coffee;

  final int? locationGroupId;

  CoffeeMachine(this.floor, {this.locationGroupId});

  @override
  String description() {
    return 'Máquina de café';
  }

  @override
  Map<String, dynamic> toMap({int? groupId}) {
    return {
      'floor': floor,
      'type': locationTypeToString(LocationType.coffeeMachine)
    };
  }

  @override
  Location clone() {
    return CoffeeMachine(floor);
  }
}
