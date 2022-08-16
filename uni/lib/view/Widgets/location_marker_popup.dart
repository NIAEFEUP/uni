import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/theme_notifier.dart';

class LocationMarkerPopup extends StatelessWidget {
  const LocationMarkerPopup(this.locationGroup,
      {this.showId = false, super.key});

  final LocationGroup locationGroup;
  final bool showId;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor.withOpacity(0.8),
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
                buildFloors(context),
          )),
    );
  }

  List<Widget> buildFloors(BuildContext context) {
    //Sort by floor
    final List<MapEntry<int, List<Location>>> entries =
        locationGroup.floors.entries.toList();
    entries.sort((current, next) => -current.key.compareTo(next.key));

    return entries.map((entry) {
      final int floor = entry.key;
      final List<Location> locations = entry.value;

      return Row(children: buildFloor(context, floor, locations));
    }).toList();
  }

  List<Widget> buildFloor(
      BuildContext context, floor, List<Location> locations) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final Color color;
    switch (themeNotifier.getTheme()) {
      case ThemeMode.light:
        color = Theme.of(context).colorScheme.primary;
        break;
      case ThemeMode.dark:
        color = Theme.of(context).colorScheme.onTertiary;
        break;
      default:
        color = Theme.of(context).colorScheme.primary;
    }

    final String floorString =
        0 <= floor && floor <= 9 //To maintain layout of popup
            ? ' $floor'
            : '$floor';

    final Widget floorCol = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Text('Andar $floorString', style: TextStyle(color: color)))
      ],
    );
    final Widget locationsColumn = Container(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        decoration:
            BoxDecoration(border: Border(left: BorderSide(color: color))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildLocations(context, locations, color),
        ));
    return [floorCol, locationsColumn];
  }

  List<Widget> buildLocations(
      BuildContext context, List<Location> locations, Color color) {
    return locations
        .map((location) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(location.description(),
                    textAlign: TextAlign.left, style: TextStyle(color: color))
              ],
            ))
        .toList();
  }
}
