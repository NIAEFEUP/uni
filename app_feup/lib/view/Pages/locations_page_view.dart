

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/Widgets/location_marker.dart';
import 'package:uni/view/Widgets/floorless_location_marker_popup.dart';
import 'package:uni/view/Widgets/location_marker_popup.dart';


class LocationsPageView extends StatelessWidget {

  final PopupController _popupLayerController = PopupController();
  final List<LocationGroup> locations;
  final RequestStatus status;
  LocationsPageView({this.locations = null, this.status = RequestStatus.none});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
      alignment: Alignment.center,
      child:
      feupMap(),
    );
  }

  FlutterMap feupMap(){
    if(this.status != RequestStatus.successful)
      return null;
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
  }
}