import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class CoffeeMachine implements Location{
  @override
  final int floor;

  @override
  final weight = 3;

  @override
  final icon = FontAwesomeIcons.coffee;

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