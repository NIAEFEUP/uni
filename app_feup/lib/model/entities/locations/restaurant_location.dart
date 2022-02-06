import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class RestaurantLocation implements Location{
  @override
  final int floor;

  @override
  final weight = 3;

  final name;

  @override
  final icon = FontAwesomeIcons.utensils;

  RestaurantLocation(this.floor,this.name);

  @override
  String description(){
    return this.name;
  }
}