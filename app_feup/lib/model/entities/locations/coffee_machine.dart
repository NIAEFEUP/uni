import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class CoffeeMachine implements Location{
  final int floor;
  final weight;

  @override
  final icon = FontAwesomeIcons.coffee;

  CoffeeMachine(this.floor, {this.weight = 2});

  String description(){
    return 'Máquina de café';
  }
}