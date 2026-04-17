import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni_ui/icons.dart';

class LocationMarker extends Marker {
  LocationMarker(
    this.latlng,
    this.locationGroup, {
    this.selectedFloor,
    this.additionalCount = 0,
  }) : super(
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
               location: locationGroup.getLocationForFloor(selectedFloor),
               additionalCount: additionalCount,
             ),
           ),
         ),
       );
  final LocationGroup locationGroup;
  final LatLng latlng;
  final int? selectedFloor;
  final int additionalCount;
}

class MarkerIcon extends StatelessWidget {
  const MarkerIcon({super.key, this.location, this.additionalCount = 0});
  final Location? location;
  final int additionalCount;

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return const SizedBox.shrink();
    }

    final markerIcon = _buildLocationIcon(context);
    if (additionalCount <= 0) {
      return markerIcon;
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        markerIcon,
        Positioned(
          top: -7,
          right: -9,
          child: _MarkerAdditionalCountBadge(count: additionalCount),
        ),
      ],
    );
  }

  Widget _buildLocationIcon(BuildContext context) {
    if (location?.icon is IconData) {
      return UniIcon(
        location?.icon as IconData,
        color: Theme.of(context).colorScheme.secondary,
        size: 12,
        solid: true,
      );
    }

    return UniIcon(
      Icons.device_unknown,
      color: Theme.of(context).colorScheme.primary,
      size: 12,
      solid: true,
    );
  }
}

class _MarkerAdditionalCountBadge extends StatelessWidget {
  const _MarkerAdditionalCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0.5),
        child: Text(
          '+$count',
          style:
              Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onError,
                fontSize: 7,
                fontWeight: FontWeight.w700,
              ) ??
              TextStyle(
                color: Theme.of(context).colorScheme.onError,
                fontSize: 7,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
