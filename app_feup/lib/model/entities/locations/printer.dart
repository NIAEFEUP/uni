import '../location.dart';

class Printer implements Location{
  @override
  final int floor;

  @override
  final weight = 1;

  @override
  final icon = 'assets/images/printer.svg';

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