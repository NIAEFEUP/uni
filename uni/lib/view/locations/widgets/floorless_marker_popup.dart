import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

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
      color: Theme.of(context).colorScheme.background.withOpacity(0.8),
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
          (location) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                location.description(),
                textAlign: TextAlign.left,
                style: TextStyle(color: FacultyMap.getFontColor(context)),
              ),
            ],
          ),
        )
        .toList();
  }
}

class LocationRow extends StatelessWidget {
  const LocationRow({required this.location, super.key});
  final Location location;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          location.description(),
          textAlign: TextAlign.left,
          style: TextStyle(color: FacultyMap.getFontColor(context)),
        ),
      ],
    );
  }
}
