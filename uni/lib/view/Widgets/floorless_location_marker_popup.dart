import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/theme_notifier.dart';

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
                buildLocations(context, locations),
          )),
    );
  }

  List<Widget> buildLocations(BuildContext context, List<Location> locations) {
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

    return locations
        .map((location) => Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(location.description(),
                      textAlign: TextAlign.left, style: TextStyle(color: color))
                ],
              ),
            ))
        .toList();
  }
}
