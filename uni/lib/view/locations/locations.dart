import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  LocationsPageState createState() => LocationsPageState();
}

class LocationsPageState extends SecondaryPageViewState
    with SingleTickerProviderStateMixin {
  ScrollController? scrollViewController;

  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<FacultyLocationsProvider, List<LocationGroup>>(
      builder: (context, locations) {
        return LocationsPageView(
          locations: locations,
        );
      },
      hasContent: (locations) => locations.isNotEmpty,
      onNullContent: Center(child: Text(S.of(context).no_places_info)),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) async {}

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navLocations.route);
}

class LocationsPageView extends StatefulWidget {
  const LocationsPageView({
    required this.locations,
    super.key,
  });

  final List<LocationGroup> locations;

  @override
  LocationsPageViewState createState() => LocationsPageViewState();
}

class LocationsPageViewState extends State<LocationsPageView> {
  static GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();
  static String searchTerms = '';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              width: constraints.maxWidth - 40,
              height: 40,
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: TextFormField(
                key: searchFormKey,
                onChanged: (text) {
                  setState(() {
                    searchTerms = removeDiacritics(text.trim().toLowerCase());
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  hintText: '${S.of(context).search}...',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                height: 10,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                alignment: Alignment.center,
                child: FacultyMap(
                  faculty: getLocation(),
                  locations: widget.locations,
                  searchFilter: searchTerms,
                  interactiveFlags:
                      InteractiveFlag.all - InteractiveFlag.rotate,
                  // TODO(bdmendes): add support for multiple faculties
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  String getLocation() {
    return 'FEUP';
  }
}
