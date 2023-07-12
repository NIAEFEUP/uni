import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/faculty_locations_provider.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

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
    return Consumer<FacultyLocationsProvider>(
      builder: (context, locationsProvider, _) {
        return LocationsPageView(
            locations: locationsProvider.locations,
            status: locationsProvider.status);
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
      Container(
        width: MediaQuery.of(context).size.width * 0.95,
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
        child: PageTitle(name: 'Locais: ${getLocation()}')
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: MediaQuery.of(context).size.height * 0.75,
        alignment: Alignment.center,
        child: (locations == null || status != RequestStatus.successful)
            ? null
            : FacultyMap(faculty: "FEUP", locations: locations!)
        //TODO:: add support for multiple faculties
      )
    ]);
  }

  String getLocation() {
    return 'FEUP';
  }
}
