import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
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
      BuildContext context, final List<LocationGroup>? filteredData1) {
    final filteredData = filteredData1!.toList();
    final store = Provider.of<Store>(context);
    final List<Object> selectedLocation =
        store.state.content['filteredLocations'];
    print(selectedLocation);
    print(filteredData1);
    for (var locationGroup in filteredData) {
      locationGroup.floors.forEach((key, value) {
        value.removeWhere((element) =>
            !selectedLocation.contains(element.runtimeType) &&
            selectedLocation.isEmpty);
      });
      locationGroup.floors.removeWhere((key, value) => value.isEmpty);
    }
    filteredData.removeWhere((element) => element.floors.isEmpty);

    print(filteredData);

    return filteredData;
  }
}
