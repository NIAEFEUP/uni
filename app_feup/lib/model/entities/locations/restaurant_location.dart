import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class RestaurantLocation implements Location{
  final int floor;
  final weight;
  final name;
  @override
  final icon = FontAwesomeIcons.utensils;

  RestaurantLocation(this.floor,this.name, {this.weight = 3});

  String description(){
    return this.name;
  }
}