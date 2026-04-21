import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni_ui/icons.dart';

class LocationMarker extends Marker {
  LocationMarker(this.latlng, this.locationGroup)
    : super(
        alignment: Alignment.center,
        height: 20,
        width: 20,
        point: latlng,
        child: Builder(
          builder: (context) => DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: MarkerIcon(
              location: locationGroup.getLocationWithMostWeight(),
            ),
          ),
        ),
      );
  final LocationGroup locationGroup;
  final LatLng latlng;
}

class MarkerIcon extends StatelessWidget {
  const MarkerIcon({super.key, this.location});
  final Location? location;

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return Container();
    }

    if (location?.icon is IconData) {
      return UniIcon(
        location?.icon as IconData,
        color: Theme.of(context).colorScheme.secondary,
        size: 12,
        solid: true,
      );
    } else {
      return UniIcon(
        Icons.device_unknown,
        color: Theme.of(context).colorScheme.secondary,
        size: 12,
        solid: true,
      );
    }
  }
}
