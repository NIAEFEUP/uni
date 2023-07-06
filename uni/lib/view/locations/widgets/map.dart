import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/locations/widgets/floorless_marker_popup.dart';
import 'package:uni/view/locations/widgets/marker.dart';
import 'package:uni/view/locations/widgets/marker_popup.dart';

class LocationsMap extends StatelessWidget {
  final PopupController _popupLayerController = PopupController();
  final List<LocationGroup> locations;
  final LatLng northEastBoundary;
  final LatLng southWestBoundary;
  final LatLng center;

  LocationsMap(
      {Key? key,
      required this.northEastBoundary,
      required this.southWestBoundary,
      required this.center,
      required this.locations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          minZoom: 17,
          maxZoom: 18,
          nePanBoundary: northEastBoundary,
          swPanBoundary: southWestBoundary,
          center: center,
          zoom: 17.5,
          rotation: 0,
          interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
          onTap: (tapPosition, latlng) => _popupLayerController.hideAllPopups(),
        ),
        nonRotatedChildren: [
          Align(
            alignment: Alignment.bottomRight,
            child: ColoredBox(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              child: GestureDetector(
                onTap: () => launchUrl(
                    Uri(host: 'openstreetmap.org', path: '/copyright')),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text("© OpenStreetMap"),
                  ),
                ),
              ),
            ),
          )
        ],
        children: <Widget>[
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const <String>['a', 'b', 'c'],
            tileProvider: CachedTileProvider(),
          ),
          PopupMarkerLayerWidget(
            options: PopupMarkerLayerOptions(
              markers: _getMarkers(),
              popupController: _popupLayerController,
              popupAnimation: const PopupAnimation.fade(
                  duration: Duration(milliseconds: 400)),
              popupBuilder: (_, Marker marker) {
                if (marker is LocationMarker) {
                  return marker.locationGroup.isFloorless
                      ? FloorlessLocationMarkerPopup(marker.locationGroup)
                      : LocationMarkerPopup(marker.locationGroup);
                }
                return const Card(child: Text('undefined'));
              },
            ),
          ),
        ]);
  }

  List<Marker> _getMarkers() {
    return locations.map((location) {
      return LocationMarker(location.latlng, location);
    }).toList();
  }
}

class CachedTileProvider extends TileProvider {
  CachedTileProvider();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return CachedNetworkImageProvider(
      getTileUrl(coordinates, options),
    );
  }
}
