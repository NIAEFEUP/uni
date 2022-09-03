import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/locations/widgets/faculty_maps.dart';
import 'package:uni/view/locations/widgets/marker.dart';
import 'package:uni/view/locations/widgets/map.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({Key? key}) : super(key: key);

  @override
  LocationsPageState createState() => LocationsPageState();
}

class LocationsPageState extends GeneralPageViewState
    with SingleTickerProviderStateMixin {
  ScrollController? scrollViewController;

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
        Tuple2<List<LocationGroup>?, RequestStatus?>>(
      converter: (store) => Tuple2(store.state.content['locationGroups'],
          store.state.content['locationGroupsStatus']),
      builder: (context, data) {
        return LocationsPageView(locations: data.item1, status: data.item2);
      },
    );
  }
}


class LocationsPageView extends StatelessWidget {
  final List<LocationGroup>? locations;
  final RequestStatus? status;

  const LocationsPageView(
      {super.key, this.locations, this.status = RequestStatus.none});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      upperMenuContainer(context),
      Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: MediaQuery.of(context).size.height * 0.75,
        alignment: Alignment.center,
        child: //TODO:: add support for multiple faculties
            getMap(context),
      )
    ]);
  }

  Container upperMenuContainer(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
        child: PageTitle(name: 'Locais: ${getLocation()}'));
    //TODO:: add support for multiple faculties
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
