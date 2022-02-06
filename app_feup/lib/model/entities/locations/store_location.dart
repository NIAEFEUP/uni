import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class StoreLocation implements Location{
  final int floor;
  final weight;
  final String name;
  @override
  final icon = FontAwesomeIcons.store;

  StoreLocation(this.floor,this.name, {this.weight = 3});

  String description(){
    return name;
  }
}