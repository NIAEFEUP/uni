import '../location.dart';

class VendingMachine implements Location{
  @override
  final int floor;

  @override
  final weight = 2;

  @override
  final icon = 'assets/images/bottle_soda_classic.svg';

  VendingMachine(this.floor);

  @override
  String description(){
    return 'Máquina de venda';
  }

  @override
  Map<String, dynamic> toMap({int groupId = null}){
    return {
      'floor' : this.floor,
      'type' : locationTypeToString(LocationType.vendingMachine)
    };
  }
}