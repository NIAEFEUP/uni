import 'package:uni/view/Fonts/location_icons.dart';

import '../location.dart';

class CoffeeMachine implements Location{
  @override
  final int floor;

  @override
  final weight = 3;

  @override
  final icon = LocationIcons.coffee;


  CoffeeMachine(this.floor);

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