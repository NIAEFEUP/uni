import 'package:uni/model/entities/locations/coffee_machine.dart';
import 'package:uni/model/entities/locations/restaurant_location.dart';
import 'package:uni/model/entities/locations/room_group_location.dart';
import 'package:uni/model/entities/locations/special_room_location.dart';
import 'package:uni/model/entities/locations/store_location.dart';
import 'package:uni/model/entities/locations/unknown_location.dart';
import 'package:uni/model/entities/locations/vending_machine.dart';
import 'package:uni/model/entities/locations/wc_location.dart';
import 'package:uni/model/entities/locations/atm.dart';
import 'package:uni/model/entities/locations/printer.dart';
import 'package:uni/model/entities/locations/room_location.dart';

enum LocationType {
  vendingMachine,
  coffeeMachine,
  rooms,
  room,
  atm,
  printer,
  restaurant,
  specialRoom,
  store,
  wc
}

String locationTypeToString(LocationType type) {
  switch (type) {
    case LocationType.vendingMachine:
      return 'VENDING_MACHINE';
    case LocationType.coffeeMachine:
      return 'COFFEE_MACHINE';
    case LocationType.rooms:
      return 'ROOMS';
    case LocationType.room:
      return 'ROOM';
    case LocationType.atm:
      return 'ATM';
    case LocationType.printer:
      return 'PRINTER';
    case LocationType.restaurant:
      return 'RESTAURANT';
    case LocationType.specialRoom:
      return 'SPECIAL_ROOM';
    case LocationType.store:
      return 'STORE';
    case LocationType.wc:
      return 'WC';
    default:
      return 'LOCATION';
  }
}

String stringTypeToReadableString(String loc) {
  switch (loc) {
    case 'COFFEE_MACHINE':
      return 'Máquinas de Café';
    case 'VENDING_MACHINE':
      return 'Máquinas de Venda';
    case 'ROOM':
      return 'Salas';
    case 'ROOMS':
      return 'Agregado de Salas';
    case 'SPECIAL_ROOM':
      return 'Salas Especiais';
    case 'ATM':
      return 'Atms';
    case 'PRINTER':
      return 'Impressoras';
    case 'RESTAURANT':
      return 'Restaurante';
    case 'STORE':
      return 'Loja';
    case 'WC':
      return 'Wc';
    default:
      return 'Outros';
  }
}

abstract class Location {
  final int floor;
  final int weight;
  bool seen = true;
  final dynamic icon; // String or IconData
  Location(this.floor, this.weight, this.icon, {locationGroupId});

  String description();

  Map<String, dynamic> toMap({int? groupId});

  Location clone();

  static Location fromJSON(Map<String, dynamic> json, int floor) {
    final Map<String, dynamic> args = json['args'];
    switch (json['type']) {
      case 'COFFEE_MACHINE':
        return CoffeeMachine(floor);
      case 'VENDING_MACHINE':
        return VendingMachine(floor);
      case 'ROOM':
        return RoomLocation(floor, args['room']);
      case 'SPECIAL_ROOM':
        return SpecialRoomLocation(floor, args['room'], args['name']);
      case 'ROOMS':
        return RoomGroupLocation(floor, args['firstRoom'], args['lastRoom']);
      case 'ATM':
        return Atm(floor);
      case 'PRINTER':
        return Printer(floor);
      case 'RESTAURANT':
        return RestaurantLocation(floor, args['name']);
      case 'STORE':
        return StoreLocation(floor, args['name']);
      case 'WC':
        return WcLocation(floor);
      default:
        return UnknownLocation(floor, json['type']);
    }
  }
}
