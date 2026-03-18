import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_osm.dart';
import 'package:uni/model/entities/faculty_config.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';

final _osmFetcherProvider = Provider<LocationFetcherOSM>((ref) {
  return LocationFetcherOSM(ref.read(selectedFacultyProvider));
});

final locationsProvider =
    AsyncNotifierProvider<FacultyLocationsNotifier, List<LocationGroup>?>(
      FacultyLocationsNotifier.new,
    );

final indoorFloorPlansProvider =
    AsyncNotifierProvider<IndoorFloorPlansNotifier, List<IndoorFloorPlan>?>(
      IndoorFloorPlansNotifier.new,
    );

final selectedFacultyProvider = StateProvider<FacultyConfig>(
  (_) => FacultyConfig.feup,
);

class FacultyLocationsNotifier
    extends CachedAsyncNotifier<List<LocationGroup>> {
  @override
  Duration? get cacheDuration => null;

  FacultyConfig get _faculty => ref.read(selectedFacultyProvider);

  @override
  Future<List<LocationGroup>> loadFromStorage() async {
    return [];
  }

  @override
  Future<List<LocationGroup>> loadFromRemote() async {
    try {
      final osmData = await ref.read(_osmFetcherProvider).getLocations();
      if (osmData.isNotEmpty) {
        return osmData;
      }
      debugPrint(
        '[Locations] OSM returned empty for ${_faculty.name}, using asset fallback',
      );
    } catch (err) {
      debugPrint('[Locations] OSM fetch failed for ${_faculty.name}: $err');
    }
    return LocationFetcherAsset(_faculty).getLocations();
  }
}

class IndoorFloorPlansNotifier
    extends CachedAsyncNotifier<List<IndoorFloorPlan>> {
  @override
  Duration? get cacheDuration => const Duration(days: 30);

  FacultyConfig get _faculty => ref.read(selectedFacultyProvider);

  @override
  Future<List<IndoorFloorPlan>> loadFromStorage() async {
    try {
      return await LocationFetcherAsset(_faculty).getIndoorFloorPlans();
    } catch (err) {
      return [];
    }
  }

  @override
  Future<List<IndoorFloorPlan>> loadFromRemote() async {
    try {
      return await ref.read(_osmFetcherProvider).getIndoorFloorPlans();
    } catch (err) {
      debugPrint(
        '[Locations] Failed to load indoor plans for ${_faculty.name}: $err',
      );
      return loadFromStorage();
    }
  }
}
