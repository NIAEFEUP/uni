import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../location.dart';

class Printer implements Location{
  @override
  final int floor;

  @override
  final weight = 1;

  @override
  final icon = FontAwesomeIcons.print;

  Printer(this.floor);

  @override
  String description(){
    return 'Impressora';
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : floor,
      'type' : locationTypeToString(LocationType.printer)
    };
  }

}