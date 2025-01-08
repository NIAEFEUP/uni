import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';

class FloorlessLocationMarkerPopup extends StatelessWidget {
  const FloorlessLocationMarkerPopup(
    this.locationGroup, {
    this.showId = false,
    super.key,
  });

  final LocationGroup locationGroup;
  final bool showId;

  @override
  Widget build(BuildContext context) {
    final locations = locationGroup.floors.values.expand((x) => x).toList();
    return Card(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          direction: Axis.vertical,
          spacing: 8,
          children: (showId
                  ? <Widget>[Text(locationGroup.id.toString())]
                  : <Widget>[]) +
              locations
                  .map((location) => LocationRow(location: location))
                  .toList(),
        ),
      ),
    );
  }

  List<Widget> buildLocations(BuildContext context, List<Location> locations) {
    return locations
        .map(
          (location) => Text(
            location.description(),
            textAlign: TextAlign.left,
            style: TextStyle(color: _getFontColor(context)),
          ),
        )
        .toList();
  }

  // TODO(thePeras): Duplicated code
  Color _getFontColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary;
  }
}

class LocationRow extends StatelessWidget {
  const LocationRow({required this.location, super.key});
  final Location location;

  @override
  Widget build(BuildContext context) {
    return Text(
      location.description(),
      textAlign: TextAlign.left,
      style: TextStyle(color: _getFontColor(context)),
    );
  }

  // TODO(thePeras): Duplicated code
  Color _getFontColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.tertiary;
  }
}
