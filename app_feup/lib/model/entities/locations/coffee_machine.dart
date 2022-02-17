import '../location.dart';

class CoffeeMachine implements Location{
  @override
  final int floor;

  @override
  final weight = 3;

  @override
  final icon = 'assets/images/coffee.svg';


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