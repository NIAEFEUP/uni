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
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/faculty_locations_provider.dart';
import 'package:uni/view/map/widgets/cached_tile_provider.dart';
import 'package:uni/view/map/widgets/floorless_marker_popup.dart';
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
  var _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    _searchTerms = '';
    _popupLayerController = PopupController();
  }

  @override
  void dispose() {
    _popupLayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultConsumer<List<LocationGroup>>(
      provider: locationsProvider,
      builder: (context, ref, locations) {
        final filteredLocations = List<LocationGroup>.from(locations);
        if (_searchTerms.trim().isNotEmpty) {
          filteredLocations.retainWhere((location) {
            final allLocations = location.floors.values.expand((x) => x);
            return allLocations.any((location) {
              return removeDiacritics(
                location.description().toLowerCase().trim(),
              ).contains(_searchTerms);
            });
          });
        }
        final bounds = LatLngBounds(
          const LatLng(41.17370, -8.59900),
          const LatLng(41.18286, -8.59298),
        );
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
                minZoom: 1,
                maxZoom: 19,
                cameraConstraint: CameraConstraint.contain(bounds: bounds),
                initialCameraFit: CameraFit.insideBounds(bounds: bounds),
                onTap:
                    (tapPosition, latlng) =>
                        _popupLayerController.hideAllPopups(),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all - InteractiveFlag.rotate,
                ),
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{r}.png',
                  tileProvider: CachedTileProvider(),
                  retinaMode: RetinaMode.isHighDensity(context),
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markers:
                        filteredLocations.map((location) {
                          return LocationMarker(location.latlng, location);
                        }).toList(),
                    popupController: _popupLayerController,
                    popupDisplayOptions: PopupDisplayOptions(
                      animation: const PopupAnimation.fade(
                        duration: Duration(milliseconds: 400),
                      ),
                      builder: (_, marker) {
                        if (marker is LocationMarker) {
                          return marker.locationGroup.isFloorless
                              ? FloorlessLocationMarkerPopup(
                                marker.locationGroup,
                              )
                              : LocationMarkerPopup(marker.locationGroup);
                        }
                        return const Card(child: Text(''));
                      },
                    ),
                  ),
                ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markers:
                        filteredLocations.map((location) {
                          return LocationMarker(location.latlng, location);
                        }).toList(),
                    popupController: _popupLayerController,
                    popupDisplayOptions: PopupDisplayOptions(
                      animation: const PopupAnimation.fade(
                        duration: Duration(milliseconds: 400),
                      ),
                      builder: (_, marker) {
                        if (marker is LocationMarker) {
                          return marker.locationGroup.isFloorless
                              ? FloorlessLocationMarkerPopup(
                                marker.locationGroup,
                              )
                              : LocationMarkerPopup(marker.locationGroup);
                        }
                        return const Card(child: Text(''));
                      },
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: PhysicalModel(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      elevation: 3,
                      child: TextFormField(
                        key: searchFormKey,
                        onChanged: (text) {
                          setState(() {
                            _searchTerms = removeDiacritics(
                              text.trim().toLowerCase(),
                            );
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom + 110,
                    left: 20,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: GestureDetector(
                        onTap:
                            () => launchUrlWithToast(
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
      },
      nullContentWidget: Center(child: Text(S.of(context).no_places_info)),
      hasContent: (locations) => locations.isNotEmpty,
    );
  }
}
