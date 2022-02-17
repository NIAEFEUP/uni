import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import '../../model/entities/location.dart';
import '../../model/entities/location_group.dart';


class LocationMarker extends Marker{
  final LocationGroup locationGroup;
  final LatLng latlng;

  LocationMarker(this.latlng, this.locationGroup)
    : super(
        anchorPos: AnchorPos.align(AnchorAlign.center),
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
          child: getIcon(locationGroup.getFirst(), ctx),
        ),
      );
  static Widget getIcon(Location location, BuildContext context){
    if(location.icon is String){
      print(location.icon);
      return Container(
        padding: const EdgeInsets.all(2.0),
        child: SvgPicture.asset(
          location.icon,
          color: Theme.of(context).accentColor

        )
      );
    } else if (location.icon is IconData){
      return Icon(
          location.icon,
          color: Theme.of(context).accentColor,
          size: 12);
    } else {
      return Icon(
          CupertinoIcons.question_diamond_fill,
          color: Theme.of(context).accentColor,
          size: 12);
    }
  }
}