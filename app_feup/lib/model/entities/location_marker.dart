import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:collection/collection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'location.dart';
import 'location_group.dart';


class LocationMarker extends Marker{
  final LocationGroup locationGroup;
  final LatLng latlng;

  LocationMarker(this.latlng, this.locationGroup)
    : super(
        anchorPos: AnchorPos.align(AnchorAlign.top),
        height: 20,
        width: 20,
        point: latlng,
        
        builder: (BuildContext ctx) => Container(

          decoration: BoxDecoration(
            color: Theme.of(ctx).backgroundColor,
            border: Border.all(
              color: Theme.of(ctx).accentColor,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Icon(
            locationGroup.getFirst().icon,
            color: Theme.of(ctx).accentColor,
            size: 12),
        ),
      );

}