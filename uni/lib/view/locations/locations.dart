//import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/faculty_locations_provider.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/locations/widgets/faculty_maps.dart';
import 'package:uni/view/locations/widgets/locations_filter_form.dart';
import 'package:uni/view/locations/widgets/marker.dart';
import 'package:uni/view/locations/widgets/map.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

import 'package:uni/view/locations/location_filter.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key}) : super(key: key);

  @override
  LocationsPageState createState() => LocationsPageState();
}

class LocationsPageState extends GeneralPageViewState
    with SingleTickerProviderStateMixin {
  ScrollController? scrollViewController;

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<FacultyLocationsProvider>(
            builder: (context, locationsProvider, _) {
          return getAlertDialog(locationsProvider.filteredLocTypes, context);
        });
      },
    );
  }

  Widget getAlertDialog(
      Map<String, bool> filteredLocations, BuildContext context) {
    return LocationsFilterForm(Map<String, bool>.from(filteredLocations));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget getBody(BuildContext context) {
    return Consumer<FacultyLocationsProvider>(
      builder: (context, locationsProvider, _) {
        final locs = locationsProvider.locations;
        final filteredLocs = locationsProvider.filteredLocTypes;
        final filtered =
            LocationFilter.getFilteredLocations(filteredLocs, locs);

        return ListView(
          children: <Widget>[
            Row(children: [
              LocationsPageView.upperMenuContainer('FEUP', context),
              //TODO:: add support for multiple faculties
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: () {
                  showAlertDialog(context);
                },
              )
            ]),
            LocationsPageView(
                locations: filtered!, status: locationsProvider.status),
          ],
        );
      },
    );
  }
}

class LocationsPageView extends StatelessWidget {
  final List<LocationGroup> locations;
  final RequestStatus? status;

  const LocationsPageView(
      {super.key, required this.locations, this.status = RequestStatus.none});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: MediaQuery.of(context).size.height * 0.75,
        alignment: Alignment.center,
        child: //TODO:: add support for multiple faculties
            getMap(context),
      )
    ]);
  }

  static Container upperMenuContainer(String faculty, BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
        child: PageTitle(
          name: 'Locais: $faculty',
          center: false,
        ));
    //TODO:: add support for multiple faculties
  }

  LocationsMap? getMap(BuildContext context) {
    if (status != RequestStatus.successful) {
      return null;
    }

    return FacultyMaps.getFeupMap(locations);
  }

  List<Marker> getMarkers(BuildContext context) {
    return locations.map((location) {
      return LocationMarker(location.latlng, location);
    }).toList();
  }
}
