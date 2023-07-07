import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/faculty_locations_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locations/widgets/faculty_maps.dart';
import 'package:uni/view/locations/widgets/marker.dart';

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
  Widget getBody(BuildContext context) {
    return LazyConsumer<FacultyLocationsProvider>(
      builder: (context, locationsProvider) {
        return LocationsPageView(
            locations: locationsProvider.locations,
            status: locationsProvider.status);
      },
    );
  }

  @override
  Future<void> handleRefresh(BuildContext context) async {}
}

class LocationsPageView extends StatelessWidget {
  final List<LocationGroup> locations;
  final RequestStatus status;

  const LocationsPageView(
      {super.key, required this.locations, this.status = RequestStatus.none});

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

  Widget getMap(BuildContext context) {
    if (status != RequestStatus.successful) {
      return const Center(child: CircularProgressIndicator());
    }
    return FacultyMaps.getFeupMap(locations);
  }

  String getLocation() {
    return 'FEUP';
  }

  List<Marker> getMarkers() {
    return locations.map((location) {
      return LocationMarker(location.latlng, location);
    }).toList();
  }
}
