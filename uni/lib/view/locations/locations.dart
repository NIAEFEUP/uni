import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  LocationsPageState createState() => LocationsPageState();
}

class LocationsPageState extends GeneralPageViewState
    with SingleTickerProviderStateMixin {
  ScrollController? scrollViewController;

  @override
  Widget getBody(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
          child: PageTitle(
            name: '${S.of(context).nav_title(DrawerItem.navLocations.title)}:'
                ' FEUP', // TODO(bdmendes): Add locations for all faculties
          ),
        ),
        LazyConsumer<FacultyLocationsProvider, List<LocationGroup>>(
          builder: (context, locations) => Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: MediaQuery.of(context).size.height * 0.75,
            alignment: Alignment.center,
            child: FacultyMap(
              faculty: 'FEUP',
              locations: locations,
              interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
            ),
          ),
          hasContent: (locations) => locations.isNotEmpty,
          onNullContent: Center(child: Text(S.of(context).no_places_info)),
        ),
      ],
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {}
}
