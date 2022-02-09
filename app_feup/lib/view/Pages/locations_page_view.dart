

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/Widgets/location_marker.dart';
import 'package:uni/model/entities/locations/coffee_machine.dart';
import 'package:uni/model/entities/locations/restaurant_location.dart';
import 'package:uni/model/entities/locations/room_group_location.dart';
import 'package:uni/model/entities/locations/room_location.dart';
import 'package:uni/model/entities/locations/special_room_location.dart';
import 'package:uni/model/entities/locations/vending_machine.dart';
import 'package:uni/view/Widgets/floorless_location_marker_popup.dart';
import 'package:uni/view/Widgets/location_marker_popup.dart';


class LocationsPageView extends StatelessWidget {

  final PopupController _popupLayerController = PopupController();
  final List<LocationGroup> locations;
  LocationsPageView(List<LocationGroup> this.locations);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      alignment: Alignment.center,
      child:
      feupMap(),
    );feupMap();
  }

  FlutterMap feupMap(){
    return FlutterMap(
      options: MapOptions(
        minZoom: 17,
        maxZoom: 18,
        nePanBoundary: LatLng(41.17986, -8.59298),
        swPanBoundary: LatLng(41.17670, -8.59991),
        center: LatLng(41.17731, -8.59522),
        zoom: 17.5,
        rotation: 0,
        interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
        onTap: (_) => _popupLayerController.hideAllPopups(),
      ),
      children: <Widget>[
        TileLayerWidget(
          options: TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: <String>['a', 'b', 'c'],
          ),
        ),
        PopupMarkerLayerWidget(
          options: PopupMarkerLayerOptions(
            markers: getMarkers(),
            popupController: _popupLayerController,
            popupAnimation:
                    PopupAnimation.fade(duration: Duration(milliseconds: 400)),
            popupBuilder: (_, Marker marker) {
              if (marker is LocationMarker) {
                if(marker.locationGroup.isFloorless) {
                  return FloorlessLocationMarkerPopup(marker.locationGroup);
                }
                else {
                  return LocationMarkerPopup(marker.locationGroup);
                }
              }
              return Card(child: const Text('undefined'));
            },
          ),
        ),
      ],
    );
  }

  List<Marker> getMarkers(){
    return locations.map((location) {
      return LocationMarker(location.latlng, location);
    }).toList();
    /*
    List<Location> locations = [];
    locations.add(CoffeeMachine(1));
    locations.add(VendingMachine(1));
    locations.add(CoffeeMachine(2));
    locations.add(VendingMachine(2));
    locations.add(RoomGroupLocation(0, 'B004', 'B007'));
    locations.add(RoomGroupLocation(1, 'B101', 'B103'));
    locations.add(RoomGroupLocation(2, 'B201', 'B206'));
    locations.add(RoomGroupLocation(3, 'B301', 'B306'));
    LocationGroup group = LocationGroup(locations: locations);
    final List<LocationMarker> markers = [];
    markers.add(LocationMarker(LatLng(41.17726, -8.59523), group));

    locations = [];
    locations.add(RoomGroupLocation(0, 'B008', 'B009'));
    locations.add(RoomLocation(1, 'B104'));
    locations.add(RoomLocation(2, 'B207'));
    locations.add(RoomGroupLocation(3, 'B307', 'B308'));
    group = LocationGroup(locations: locations);
    markers.add(LocationMarker(LatLng(41.17736, -8.59539), group));

    locations = [];
    locations.add(CoffeeMachine(0));
    locations.add(VendingMachine(0));
    group = LocationGroup(locations: locations, isFloorless: true);
    markers.add(LocationMarker(LatLng(41.17785, -8.59755), group));

    group = LocationGroup(locations:
    [RestaurantLocation(0, 'Bar da biblioteca')]
        , isFloorless: true);
    markers.add(LocationMarker(LatLng(41.17744, -8.59487), group));

    group = LocationGroup(locations:
    [RestaurantLocation(0, 'Bar de minas')]);
    markers.add(LocationMarker(LatLng(41.17853, -8.59745
    ), group));

    group = LocationGroup(locations:
    [RestaurantLocation(0, 'Cantina da Feup')]);
    markers.add(LocationMarker(LatLng(41.17619, -8.59548), group));

    group = LocationGroup(locations:
    [SpecialRoomLocation(3,'B315','Sala do NIFEUP')]);
    markers.add(LocationMarker(LatLng(41.1774, -8.59601), group));
    return markers;

     */
    return null;
  }
}