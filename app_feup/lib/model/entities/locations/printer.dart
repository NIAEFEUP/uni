import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class Printer implements Location{
  final int floor;
  final weight;

  @override
  final icon = FontAwesomeIcons.print;

  Printer(this.floor, {this.weight = 1});

  String description(){
    return 'Impressora';
  }
}