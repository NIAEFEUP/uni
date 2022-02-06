import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class VendingMachine implements Location{
  final int floor;
  final weight;

  @override
  final icon = FontAwesomeIcons.cookie;

  VendingMachine(this.floor, {this.weight = 1});

  String description(){
    return 'Máquina de venda';
  }
}