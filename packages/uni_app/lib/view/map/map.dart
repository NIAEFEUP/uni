import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:uni/controller/networking/url_launcher.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/lazy/faculty_locations_provider.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/widgets/bottom_navigation_bar.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/map/widgets/cached_tile_provider.dart';
import 'package:uni/view/map/widgets/floorless_marker_popup.dart';
import 'package:uni/view/map/widgets/marker.dart';
import 'package:uni/view/map/widgets/marker_popup.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() => MapPageStateView();
}

class MapPageStateView extends State<MapPage> {
  ScrollController? scrollViewController;
  GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();
  String searchTerms = '';
  PopupController _popupLayerController = PopupController();

  @override
  void initState() {
    super.initState();
    searchTerms = '';
    _popupLayerController = PopupController();
  }

  @override
  void dispose() {
    _popupLayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: const AppBottomNavbar(),
      body: LazyConsumer<FacultyLocationsProvider, List<LocationGroup>>(
        builder: (context, locations) {
          final filteredLocations = List<LocationGroup>.from(locations);
          if (searchTerms.trim().isNotEmpty) {
            filteredLocations.retainWhere((location) {
              final allLocations = location.floors.values.expand((x) => x);
              return allLocations.any((location) {
                return removeDiacritics(
                  location.description().toLowerCase().trim(),
                ).contains(
                  searchTerms,
                );
              });
            });
          }
          return FlutterMap(
            options: MapOptions(
              minZoom: 17,
              maxZoom: 18,
              nePanBoundary: const LatLng(41.17986, -8.59298),
              swPanBoundary: const LatLng(41.17670, -8.59991),
              center: const LatLng(41.17731, -8.59522),
              zoom: 17.5,
              interactiveFlags: InteractiveFlag.all - InteractiveFlag.rotate,
              onTap: (tapPosition, latlng) =>
                  _popupLayerController.hideAllPopups(),
            ),
            nonRotatedChildren: [
              Align(
                alignment: Alignment.bottomRight,
                child: ColoredBox(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                  child: GestureDetector(
                    onTap: () => launchUrlWithToast(
                      context,
                      'https://www.openstreetmap.org/copyright',
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text('©OpenStreetMap @CARTO'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            children: <Widget>[
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{r}.png',
                subdomains: const <String>['a', 'b', 'c'],
                tileProvider: CachedTileProvider(),
              ),
              PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
                  markers: filteredLocations.map((location) {
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
                            ? FloorlessLocationMarkerPopup(marker.locationGroup)
                            : LocationMarkerPopup(marker.locationGroup);
                      }
                      return const Card(child: Text(''));
                    },
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: PhysicalModel(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    elevation: 3,
                    child: TextFormField(
                      key: searchFormKey,
                      onChanged: (text) {
                        setState(() {
                          searchTerms =
                              removeDiacritics(text.trim().toLowerCase());
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
            ],
          );
        },
        hasContent: (locations) => locations.isNotEmpty,
        onNullContent: Center(child: Text(S.of(context).no_places_info)),
      ),
    );
  }
}
