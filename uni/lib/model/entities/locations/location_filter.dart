import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/locations/printer.dart';
import 'package:uni/model/entities/locations/restaurant_location.dart';
import 'package:uni/model/entities/locations/room_group_location.dart';
import 'package:uni/model/entities/locations/room_location.dart';
import 'package:uni/model/entities/locations/special_room_location.dart';
import 'package:uni/model/entities/locations/store_location.dart';
import 'package:uni/model/entities/locations/unknown_location.dart';
import 'package:uni/model/entities/locations/vending_machine.dart';
import 'package:uni/model/entities/locations/wc_location.dart';

import '../location_group.dart';
import 'atm.dart';
import 'coffee_machine.dart';

//
// NOTA : SECALHAR ISTO É UM CONTROLADOR
//
//
// Neste momento deve haver um problema com o guardar na cache
// ... provavelmente n usar o removewhere
//

class LocationFilter {
  static List<Object> selectedLocation = LocationType.values;

  static List<LocationGroup>? getFilteredLocations(
      final List<LocationGroup>? filteredData1) {
    final filteredData = filteredData1!.toList();
    for (var locationGroup in filteredData) {
      locationGroup.floors.forEach((key, value) {
        value.removeWhere((element) =>
            !selectedLocation.contains(element.runtimeType) &&
            selectedLocation.isNotEmpty);
      });
      locationGroup.floors.removeWhere((key, value) => value.isEmpty);
    }
    filteredData.removeWhere((element) => element.floors.isEmpty);

    return filteredData;
  }

  // TODO: PK O SWITCH ?? n dá para tirar ?
  static removeFilter(LocationType? type) {
    switch (type) {
      case LocationType.vendingMachine:
        LocationFilter.selectedLocation.remove(VendingMachine);
        break;
      case LocationType.coffeeMachine:
        LocationFilter.selectedLocation.remove(CoffeeMachine);
        break;
      case LocationType.rooms:
        LocationFilter.selectedLocation.remove(RoomGroupLocation);
        break;
      case LocationType.room:
        LocationFilter.selectedLocation.remove(RoomLocation);
        break;
      case LocationType.atm:
        LocationFilter.selectedLocation.remove(Atm);
        break;
      case LocationType.printer:
        LocationFilter.selectedLocation.remove(Printer);
        break;
      case LocationType.restaurant:
        LocationFilter.selectedLocation.remove(RestaurantLocation);
        break;
      case LocationType.specialRoom:
        LocationFilter.selectedLocation.remove(SpecialRoomLocation);
        break;
      case LocationType.store:
        LocationFilter.selectedLocation.remove(StoreLocation);
        break;
      case LocationType.wc:
        LocationFilter.selectedLocation.remove(WcLocation);
        break;
      default:
        LocationFilter.selectedLocation.remove(UnknownLocation);
        break;
    }
  }

  static addFilter(LocationType? type) {
    switch (type) {
      case LocationType.vendingMachine:
        LocationFilter.selectedLocation.add(VendingMachine);
        break;
      case LocationType.coffeeMachine:
        LocationFilter.selectedLocation.add(CoffeeMachine);
        break;
      case LocationType.rooms:
        LocationFilter.selectedLocation.add(RoomGroupLocation);
        break;
      case LocationType.room:
        LocationFilter.selectedLocation.add(RoomLocation);
        break;
      case LocationType.atm:
        LocationFilter.selectedLocation.add(Atm);
        break;
      case LocationType.printer:
        LocationFilter.selectedLocation.add(Printer);
        break;
      case LocationType.restaurant:
        LocationFilter.selectedLocation.add(RestaurantLocation);
        break;
      case LocationType.specialRoom:
        LocationFilter.selectedLocation.add(SpecialRoomLocation);
        break;
      case LocationType.store:
        LocationFilter.selectedLocation.add(StoreLocation);
        break;
      case LocationType.wc:
        LocationFilter.selectedLocation.add(WcLocation);
        break;
      default:
        LocationFilter.selectedLocation.add(UnknownLocation);
        break;
    }
  }
}
