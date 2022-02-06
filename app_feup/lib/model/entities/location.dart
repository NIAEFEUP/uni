
enum LocationType{
  vendingMachine,
  coffeeMachine,
  rooms,
  room,
  atm,
  printer
}

abstract class Location{
  final int floor;
  final int weight;
  final icon;
  Location(this.floor, {this.weight = null, this.icon = null});

  String description();
}