import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

class LocationMarkerPopup extends StatelessWidget {
  const LocationMarkerPopup(this.locationGroup,
      {this.showId = false, super.key});

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
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 8,
            children: (showId
                    ? <Widget>[Text(locationGroup.id.toString())]
                    : <Widget>[]) +
                getEntries().map((entry) =>
                    Floor(floor: entry.key, locations: entry.value)
                ).toList(),
          )),
    );
  }

  List<MapEntry<int, List<Location>>> getEntries() {
    final List<MapEntry<int, List<Location>>> entries =
    locationGroup.floors.entries.toList();
    entries.sort((current, next) => -current.key.compareTo(next.key));
    return entries;
  }
}

class Floor extends StatelessWidget {
  final List<Location> locations;
  final int floor;

  const Floor({Key? key, required this.locations, required this.floor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color fontColor = FacultyMap.getFontColor(context);

    final String floorString =
    0 <= floor && floor <= 9 //To maintain layout of popup
        ? ' $floor'
        : '$floor';

    final Widget floorCol = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child:
            Text('Andar $floorString', style: TextStyle(color: fontColor)))
      ],
    );
    final Widget locationsColumn = Container(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        decoration:
        BoxDecoration(border: Border(left: BorderSide(color: fontColor))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: locations
              .map((location) =>
                  LocationRow(location: location, color: fontColor))
              .toList(),
        ));
    return Row(children: [floorCol, locationsColumn]);
  }
}

class LocationRow extends StatelessWidget {
  final Location location;
  final Color color;
  
  const LocationRow({Key? key, required this.location, required this.color})
      : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(location.description(),
            textAlign: TextAlign.left, style: TextStyle(color: color))
      ],
    );
  }
}
