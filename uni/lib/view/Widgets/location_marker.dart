import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/location.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/theme_notifier.dart';


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
              color: Theme.of(ctx).colorScheme.primary,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))
          ),
          child: getIcon(locationGroup.getLocationWithMostWeight(), ctx),
        ),
      );
  static Widget getIcon(Location? location, BuildContext context){
    if(location == null){
      return Container();
    }

    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final Color color;
    switch(themeNotifier.getTheme()){
      case ThemeMode.light:
        color = Theme.of(context).colorScheme.primary;
        break;
      case ThemeMode.dark:
        color = Theme.of(context).colorScheme.onTertiary;
        break;
      default:
        color = Theme.of(context).colorScheme.primary;
    }

    if (location.icon is IconData){
      return Icon(
          location.icon,
          color: color,
          size: 12);
    } else {
      return Icon(
          Icons.device_unknown,
          color: color,
          size: 12);
    }
  }
}