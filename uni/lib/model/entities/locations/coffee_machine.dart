import 'package:uni/view/Fonts/location_icons.dart';

import '../location.dart';

class CoffeeMachine implements Location{
  @override
  final int floor;

  @override
  final weight = 3;

  @override
  final icon = LocationIcons.coffee;

  final int locationGroupId;

  CoffeeMachine(this.floor, {this.locationGroupId = null});

  @override
  String description(){
    return 'Máquina de café';
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : floor,
      'type' : locationTypeToString(LocationType.coffeeMachine)
    };
  }
}