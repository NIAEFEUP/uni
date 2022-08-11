import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/Widgets/faculty_maps/faculty_maps.dart';
import 'package:uni/view/Widgets/faculty_maps/locations_map.dart';
import 'package:uni/view/Widgets/location_marker.dart';

class LocationsPageView extends StatelessWidget {
  final List<LocationGroup>? locations;
  final RequestStatus? status;

  const LocationsPageView(
      {super.key, this.locations, this.status = RequestStatus.none});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          upperMenuContainer(context),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: MediaQuery.of(context).size.height * 0.75,
            alignment: Alignment.center,
            child: //TODO:: add support for multiple faculties
                getMap(context),
          )
        ]));
  }

  Container upperMenuContainer(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
        child: Text('Locais: ${getLocation()}',
            //TODO:: add support for multiple faculties
            textAlign: TextAlign.left,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.apply(fontSizeDelta: 7)));
  }

  LocationsMap? getMap(BuildContext context) {
    if (locations == null || status != RequestStatus.successful) {
      return null;
    }
    return FacultyMaps.getFeupMap(locations!);
  }

  String getLocation() {
    return 'FEUP';
  }

  List<Marker> getMarkers() {
    return locations!.map((location) {
      return LocationMarker(location.latlng, location);
    }).toList();
  }
}
