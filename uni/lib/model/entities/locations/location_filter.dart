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
  static List<LocationGroup>? getFilteredLocations(
      Map<String, bool> filteredLocations,
      final List<LocationGroup>? filteredData1) {
    final filteredData = filteredData1!.toList();

    final List<dynamic> selectedLocation = filteredLocations.entries
        .where((entry) => entry.value)
        .map((entry) => stringToLocationClass(entry.key))
        .toList();

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

  static stringToLocationClass(String loc) {
    switch (loc) {
      case 'COFFEE_MACHINE':
        return CoffeeMachine;
      case 'VENDING_MACHINE':
        return VendingMachine;
      case 'ROOM':
        return RoomLocation;
      case 'SPECIAL_ROOM':
        return SpecialRoomLocation;
      case 'ROOMS':
        return RoomGroupLocation;
      case 'ATM':
        return Atm;
      case 'PRINTER':
        return Printer;
      case 'RESTAURANT':
        return RestaurantLocation;
      case 'STORE':
        return StoreLocation;
      case 'WC':
        return WcLocation;
      default:
        return UnknownLocation;
    }
  }
}
