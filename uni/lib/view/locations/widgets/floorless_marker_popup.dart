import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/locations/widgets/faculty_maps.dart';

class FloorlessLocationMarkerPopup extends StatelessWidget {
  const FloorlessLocationMarkerPopup(this.locationGroup,
      {this.showId = false, super.key});

  final LocationGroup locationGroup;
  final bool showId;

  @override
  Widget build(BuildContext context) {
    final List<Location> locations =
        locationGroup.floors.values.expand((x) => x).toList();
    return Card(
      color: Theme.of(context).colorScheme.background.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 8,
            children: (showId
                    ? <Widget>[Text(locationGroup.id.toString())]
                    : <Widget>[]) +
                buildLocations(context, locations),
          )),
    );
  }

  List<Widget> buildLocations(BuildContext context, List<Location> locations) {
    return locations
        .map((location) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(location.description(),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: FacultyMaps.getFontColor(context)))
              ],
            ))
        .toList();
  }
}
