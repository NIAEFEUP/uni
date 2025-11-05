import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni_ui/icons.dart';
import 'package:uni_ui/theme.dart';

class LocationMarker extends Marker {
  LocationMarker(this.latlng, this.locationGroup)
    : super(
        alignment: Alignment.center,
        height: 20,
        width: 20,
        point: latlng,
        child: Builder(
          builder:
              (context) => DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).background,
                  border: Border.all(color: Theme.of(context).primaryVibrant),
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

    final fontColor = _getFontColor(context);
    if (location?.icon is IconData) {
      return UniIcon(
        location?.icon as IconData,
        color: fontColor,
        size: 12,
        solid: true,
      );
    } else {
      return UniIcon(
        Icons.device_unknown, // not in icons.dart
        color: fontColor,
        size: 12,
        solid: true,
      );
    }
  }

  // TODO(thePeras): Duplicated code
  Color _getFontColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryVibrant
        : Theme.of(context).details;
  }
}
