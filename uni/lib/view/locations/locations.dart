import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<FacultyLocationsProvider>(
      builder: (context, locationsProvider) {
        return LocationsPageView(
          locations: locationsProvider.locations,
          status: locationsProvider.status,
        );
      },
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {}
}

class LocationsPageView extends StatefulWidget {
  const LocationsPageView({
    required this.locations,
    required this.status,
    super.key,
  });

  final List<LocationGroup> locations;
  final RequestStatus status;

  @override
  LocationsPageViewState createState() => LocationsPageViewState();
}

class LocationsPageViewState extends State<LocationsPageView> {
  static GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();
  static String searchTerms = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            PageTitle(
              name: '${S.of(context).nav_title(DrawerItem.navLocations.title)}:'
                  ' ${getLocation()}',
              center: false,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: TextFormField(
                  key: searchFormKey,
                  onChanged: (text) {
                    setState(() {
                      searchTerms = text;
                    });
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    hintText: 'Enter a search term',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            height: 10,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            alignment: Alignment.center,
            child: RequestDependentWidgetBuilder(
              status: widget.status,
              builder: () => FacultyMap(
                faculty: getLocation(),
                locations: widget.locations,
                searchFilter: searchTerms,
              ),
              hasContentPredicate: widget.locations.isNotEmpty,
              onNullContent: Center(child: Text(S.of(context).no_places_info)),
            ),
            // TODO(bdmendes): add support for multiple faculties
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  String getLocation() {
    return 'FEUP';
  }
}
