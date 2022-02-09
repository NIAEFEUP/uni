import 'package:flutter/material.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';

class FloorlessLocationMarkerPopup extends StatelessWidget {
  const FloorlessLocationMarkerPopup(this.locationGroup, {this.debug = false});
  final LocationGroup locationGroup;
  final bool debug;
  @override
  Widget build(BuildContext context) {
    final bool debug = true;

    final List<Location> locations =
      locationGroup.floors.values.expand((x) => x).toList();
    return Card(
      color: Theme.of(context).backgroundColor.withOpacity(0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child:
          Wrap(
            direction: Axis.vertical,
            spacing: 8,
            children:
            (debug ? <Widget>[Text(locationGroup.id.toString())] : <Widget>[]) +
            buildLocations(context, locations),
          )
      ),
    );
  }


  List<Widget> buildLocations(BuildContext context, List<Location> locations){
    return locations.map((location) =>
        Row(
          mainAxisSize: MainAxisSize.min,
          children:
            [Text(
            location.description(),
            textAlign: TextAlign.left,
            style: TextStyle(color: Theme.of(context).accentColor))],
        )).toList();
  }
}