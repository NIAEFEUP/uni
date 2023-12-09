import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

class LocationMarkerPopup extends StatelessWidget {
  const LocationMarkerPopup(
    this.locationGroup, {
    this.showId = false,
    super.key,
  });

  final LocationGroup locationGroup;
  final bool showId;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.background.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          clipBehavior: Clip.antiAlias,
          direction: Axis.vertical,
          spacing: 8,
          children: (showId
                  ? <Widget>[Text(locationGroup.id.toString())]
                  : <Widget>[]) +
              getEntries()
                  .map(
                    (entry) => Floor(floor: entry.key, locations: entry.value),
                  )
                  .toList(),
        ),
      ),
    );
  }

  List<MapEntry<int, List<Location>>> getEntries() {
    return locationGroup.floors.entries.toList()
      ..sort((current, next) => -current.key.compareTo(next.key));
  }
}

class Floor extends StatelessWidget {
  const Floor({required this.locations, required this.floor, super.key});

  final List<Location> locations;
  final int floor;

  @override
  Widget build(BuildContext context) {
    final fontColor = FacultyMap.getFontColor(context);

    final floorString = 0 <= floor && floor <= 9 //To maintain layout of popup
        ? ' $floor'
        : '$floor';

    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                '${S.of(context).floor} $floorString',
                style: TextStyle(color: fontColor),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          decoration:
              BoxDecoration(border: Border(left: BorderSide(color: fontColor))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: locations
                .map(
                  (location) =>
                      LocationRow(location: location, color: fontColor),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class LocationRow extends StatelessWidget {
  const LocationRow({required this.location, required this.color, super.key});

  final Location location;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          location.description(),
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
