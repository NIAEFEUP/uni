import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locations/widgets/faculty_map.dart';

class MapCard extends GenericCard {
  MapCard({super.key});

  const MapCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  @override
  String getTitle(BuildContext context) =>
      '${S.of(context).nav_title(NavigationItem.navLocations.route)}: FEUP';

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navLocations.route}');

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<FacultyLocationsProvider, List<LocationGroup>>(
      builder: buildMapView,
      hasContent: (locations) => locations.isNotEmpty,
      onNullContent: const Center(child: Text('Erro')),
    );
  }

  @override
  void onRefresh(BuildContext context) {
    Provider.of<FacultyLocationsProvider>(context, listen: false)
        .forceRefresh(context);
  }

  Widget buildMapView(BuildContext context, List<LocationGroup> locations) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/${NavigationItem.navLocations.route}'),
      child: AbsorbPointer(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          height: MediaQuery.of(context).size.height * 0.3,
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FacultyMap(
              faculty: 'FEUP',
              locations: locations,
              interactiveFlags: InteractiveFlag.none,
              searchFilter: '',
            ),
          ),
        ),
      ),
    );
  }
}
