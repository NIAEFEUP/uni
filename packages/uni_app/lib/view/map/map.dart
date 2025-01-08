import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/top_navigation_bar.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends GeneralPageViewState {
  ScrollController? scrollViewController;

  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<FacultyLocationsProvider, List<LocationGroup>>(
      builder: (context, locations) {
        return MapPageView(
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

  @override
  AppTopNavbar? getTopNavbar(BuildContext context) {
    return const AppTopNavbar(
      heightSize: Size.fromHeight(0),
    );
  }
}

class MapPageView extends StatefulWidget {
  const MapPageView({
    required this.locations,
    super.key,
  });

  final List<LocationGroup> locations;

  @override
  MapPageViewState createState() => MapPageViewState();
}

class MapPageViewState extends State<MapPageView> {
  static GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();
  static String searchTerms = '';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                key: searchFormKey,
                onChanged: (text) {
                  setState(() {
                    searchTerms = removeDiacritics(text.trim().toLowerCase());
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SvgPicture.asset(
                      'assets/images/logo_dark.svg',
                      semanticsLabel: 'search',
                      width: 10,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  hintText: '${S.of(context).search}...',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FacultyMap(
                faculty: getLocation(),
                locations: widget.locations,
                searchFilter: searchTerms,
                interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
                // TODO(bdmendes): add support for multiple faculties
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
