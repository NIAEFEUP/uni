//import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/locations/widgets/faculty_maps.dart';
import 'package:uni/view/locations/widgets/locations_filter_form.dart';
import 'package:uni/view/locations/widgets/marker.dart';
import 'package:uni/view/locations/widgets/map.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

import 'package:uni/model/entities/locations/location_filter.dart';

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
        return StoreConnector<AppState, Map<String, bool>?>(
            converter: (store) => store.state.content['filteredLocations'],
            builder: (context, filteredLocations) {
              return getAlertDialog(filteredLocations ?? {}, context);
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
    return StoreConnector<AppState,
        Tuple2<List<LocationGroup>, RequestStatus?>>(
      converter: (store) {
        final locations = store.state.content['locationGroups'];

        final Map<String, bool> filteredLocations =
            store.state.content['filteredLocations'] ?? <String, bool>{};

        final filtered =
            LocationFilter.getFilteredLocations(filteredLocations, locations)!;
        return Tuple2(filtered, store.state.content['locationGroupsStatus']);
      },
      builder: (context, data) {
        return ListView(
          children: <Widget>[
            Row(children: [
              LocationsPageView.upperMenuContainer('FEUP', context),
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: () {
                  showAlertDialog(context);
                },
              )
            ]),
            LocationsPageView(locations: data.item1, status: data.item2),
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
        child: PageTitle(name: 'Locais: $faculty'));
    //TODO:: add support for multiple faculties0
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
