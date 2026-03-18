import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/riverpod/faculty_locations_provider.dart';
import 'package:uni/view/map/collapsed_location_cluster.dart';
import 'package:uni/view/map/widgets/amenity_filter_bar.dart';
import 'package:uni/view/map/widgets/floor_selector_button.dart';
import 'package:uni/view/map/widgets/floorless_marker_popup.dart';
import 'package:uni/view/map/widgets/indoor_floor_layer.dart';
import 'package:uni/view/map/widgets/marker.dart';
import 'package:uni/view/map/widgets/marker_popup.dart';
import 'package:uni/view/widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni_ui/theme.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => MapPageStateView();
}

class MapPageStateView extends ConsumerState<MapPage> {
  ScrollController? scrollViewController;
  final searchFormKey = GlobalKey<FormState>();
  var _searchTerms = '';
  late final PopupController _popupLayerController;
  LatLngBounds? _bounds;
  int? _selectedFloor;
  bool _showIndoorLayer = false;
  AmenityFilter? _selectedAmenity;

  @override
  void initState() {
    super.initState();
    _searchTerms = '';
    _popupLayerController = PopupController();
    _selectedFloor = null;
    _selectedAmenity = null;
  }

  @override
  void dispose() {
    _popupLayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(locationsProvider);
    final List<LocationGroup> locations = locationsAsync.when(
      data: (data) => data ?? <LocationGroup>[],
      loading: () => <LocationGroup>[],
      error: (_, _) => <LocationGroup>[],
    );
    final isLocationsLoading = locationsAsync.isLoading;

    final indoorPlansAsync = ref.watch(indoorFloorPlansProvider);
    final List<IndoorFloorPlan> indoorPlans = indoorPlansAsync.when(
      data: (data) => data ?? <IndoorFloorPlan>[],
      loading: () => <IndoorFloorPlan>[],
      error: (_, _) => <IndoorFloorPlan>[],
    );
    final isIndoorPlansLoaded = indoorPlansAsync.hasValue;

    final isMapLoading = isLocationsLoading || !isIndoorPlansLoaded;
    final normalizedSearchTerm = _searchTerms.trim();

    final matchingRoomsByFloor = <int, List<IndoorRoom>>{};
    if (normalizedSearchTerm.isNotEmpty) {
      for (final plan in indoorPlans) {
        final matchingRooms = plan.rooms
            .where((room) => _matchesRoomSearch(room, normalizedSearchTerm))
            .toList();
        if (matchingRooms.isNotEmpty) {
          matchingRoomsByFloor
              .putIfAbsent(plan.floor, () => <IndoorRoom>[])
              .addAll(matchingRooms);
        }
      }
    }

    final hasRoomSearchResults = matchingRoomsByFloor.isNotEmpty;
    var effectiveFloor = _selectedFloor;
    if (hasRoomSearchResults) {
      if (_selectedFloor != null &&
          matchingRoomsByFloor.containsKey(_selectedFloor)) {
        effectiveFloor = _selectedFloor;
      } else {
        final candidateFloors = matchingRoomsByFloor.keys.toList()
          ..sort((a, b) => b.compareTo(a));
        effectiveFloor = candidateFloors.first;
      }
    }
    final shouldShowIndoorLayer = _showIndoorLayer || hasRoomSearchResults;

    // Fall back to faculty bounds while locations are loading
    final faculty = ref.watch(selectedFacultyProvider);
    final fallbackBounds = LatLngBounds(
      LatLng(faculty.bounds.minLat, faculty.bounds.minLon),
      LatLng(faculty.bounds.maxLat, faculty.bounds.maxLon),
    );
    if (locations.isNotEmpty) {
      _bounds ??= LatLngBounds.fromPoints(
        locations.map((l) => l.latlng).toList(),
        drawInSingleWorld: true,
      );
    }
    final bounds = _bounds ?? fallbackBounds;

    final filteredLocations = List<LocationGroup>.from(locations);
    if (normalizedSearchTerm.isNotEmpty) {
      filteredLocations.retainWhere((location) {
        final allLocations = location.floors.values.expand((x) => x);
        return allLocations.any((loc) {
          return _normalizeSearchText(
            loc.description(),
          ).contains(normalizedSearchTerm);
        });
      });
    }
    if (_selectedFloor != null) {
      filteredLocations.retainWhere((location) {
        return location.floors.containsKey(_selectedFloor);
      });
    }
    if (_selectedAmenity != null) {
      filteredLocations.retainWhere((locationGroup) {
        final allLocations = locationGroup.floors.values.expand((x) => x);
        return allLocations.any((loc) => _selectedAmenity!.matches(loc));
      });
    }

    final collapsedMarkerGroups =
        CollapsedLocationCluster.collapseNearbyAmenities(filteredLocations);

    // Combine floors from location groups and indoor floor plans.
    final locationFloors = locations
        .expand((group) => group.floors.keys)
        .toSet();
    final indoorFloors = indoorPlans.map((plan) => plan.floor).toSet();
    final List<int> allFloors = <int>{
      ...locationFloors,
      ...indoorFloors,
    }.where((f) => f != 7).toList()..sort((a, b) => b.compareTo(a));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemOverlayStyles.base.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        bottomNavigationBar: const AppBottomNavbar(),
        body: FlutterMap(
          options: MapOptions(
            minZoom: 16,
            maxZoom: 19,
            initialCenter: bounds.center,
            initialZoom: 17,
            initialCameraFit: CameraFit.insideBounds(bounds: bounds),
            cameraConstraint: CameraConstraint.containCenter(bounds: bounds),
            onTap: (tapPosition, latlng) {
              _popupLayerController.hideAllPopups();
              FocusScope.of(context).unfocus();
            },
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all - InteractiveFlag.rotate,
            ),
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate:
                  'https://basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{r}.png',
              tileProvider: NetworkTileProvider(
                cachingProvider:
                    BuiltInMapCachingProvider.getOrCreateInstance(),
              ),
              retinaMode: RetinaMode.isHighDensity(context),
              maxNativeZoom: 20,
            ),
            if (shouldShowIndoorLayer && effectiveFloor != null)
              IndoorFloorLayer(
                floorPlans: indoorPlans,
                selectedFloor: effectiveFloor,
                roomFilter: hasRoomSearchResults
                    ? (room) => _matchesRoomSearch(room, normalizedSearchTerm)
                    : null,
              ),
            PopupMarkerLayer(
              options: PopupMarkerLayerOptions(
                markers: collapsedMarkerGroups.map((cluster) {
                  return LocationMarker(
                    cluster.locationGroup.latlng,
                    cluster.locationGroup,
                    selectedFloor: _selectedFloor,
                    additionalCount: cluster.additionalAmenities,
                  );
                }).toList(),
                popupController: _popupLayerController,
                popupDisplayOptions: PopupDisplayOptions(
                  animation: const PopupAnimation.fade(
                    duration: Duration(milliseconds: 400),
                  ),
                  builder: (_, marker) {
                    if (marker is LocationMarker) {
                      return marker.locationGroup.isFloorless
                          ? FloorlessLocationMarkerPopup(marker.locationGroup)
                          : LocationMarkerPopup(marker.locationGroup);
                    }
                    return const Card(child: Text(''));
                  },
                ),
              ),
            ),
            if (isIndoorPlansLoaded)
              Align(
                alignment: Alignment.bottomRight,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 68),
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: () {
                        setState(() {
                          _showIndoorLayer = !_showIndoorLayer;
                        });
                      },
                      child: Icon(
                        _showIndoorLayer ? Icons.layers_clear : Icons.layers,
                      ),
                    ),
                  ),
                ),
              ),
            if (isIndoorPlansLoaded)
              Align(
                alignment: Alignment.bottomRight,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 10),
                    child: FloorSelectorButton(
                      floors: allFloors,
                      selectedFloor: effectiveFloor,
                      onFloorSelected: (floor) {
                        setState(() {
                          _selectedFloor = floor;
                          _popupLayerController.hideAllPopups();
                        });
                      },
                    ),
                  ),
                ),
              ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PhysicalModel(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.secondary,
                      elevation: 4,
                      child: TextFormField(
                        key: searchFormKey,
                        onChanged: (text) {
                          setState(() {
                            _searchTerms = _normalizeSearchText(text);
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
                              width: 44,
                              height: 25,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(10),
                          hintText: S.of(context).search_here,
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AmenityFilterBar(
                      selectedAmenity: _selectedAmenity,
                      onAmenitySelected: (amenity) {
                        setState(() {
                          _selectedAmenity = amenity;
                          _popupLayerController.hideAllPopups();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (isMapLoading) const Center(child: CircularProgressIndicator()),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewPaddingOf(context).bottom + 110,
                left: 20,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: GestureDetector(
                    onTap: () => launchUrlWithToast(
                      context,
                      'https://www.openstreetmap.org/copyright',
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 8,
                      ),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          '©OpenStreetMap @CARTO',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _normalizeSearchText(String? text) {
    return removeDiacritics((text ?? '').toLowerCase().trim());
  }

  bool _matchesRoomSearch(IndoorRoom room, String normalizedSearchTerm) {
    if (normalizedSearchTerm.isEmpty) {
      return false;
    }

    return _normalizeSearchText(room.name).contains(normalizedSearchTerm) ||
        _normalizeSearchText(room.ref).contains(normalizedSearchTerm);
  }
}
