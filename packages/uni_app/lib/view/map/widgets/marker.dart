import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';

class LocationMarker extends Marker {
  LocationMarker(this.latlng, this.locationGroup)
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 20,
          width: 20,
          point: latlng,
          builder: (context) => DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: MarkerIcon(
              location: locationGroup.getLocationWithMostWeight(),
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

    final fontColor = _getFontColor(context);
    if (location?.icon is IconData) {
      return Icon(location?.icon as IconData, color: fontColor, size: 12);
    } else {
      return Icon(Icons.device_unknown, color: fontColor, size: 12);
    }
  }

  // TODO(thePeras): Duplicated code
  Color _getFontColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary;
  }
}
