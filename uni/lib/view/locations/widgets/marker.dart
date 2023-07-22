import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

class LocationMarker extends Marker {
  final LocationGroup locationGroup;
  final LatLng latlng;

  LocationMarker(this.latlng, this.locationGroup)
      : super(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          height: 20,
          width: 20,
          point: latlng,
          builder: (BuildContext ctx) => Container(
            decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.background,
                border: Border.all(
                  color: Theme.of(ctx).colorScheme.primary,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child:
                MarkerIcon(location: locationGroup.getLocationWithMostWeight()),
          ),
        );
}

class MarkerIcon extends StatelessWidget {
  final Location? location;

  const MarkerIcon({Key? key, this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return Container();
    }

    final Color fontColor = FacultyMap.getFontColor(context);
    if (location?.icon is IconData) {
      return Icon(location?.icon, color: fontColor, size: 12);
    } else {
      return Icon(Icons.device_unknown, color: fontColor, size: 12);
    }
  }
}
