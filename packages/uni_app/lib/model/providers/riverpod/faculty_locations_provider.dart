import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_osm.dart';
import 'package:uni/model/entities/indoor_floor_plan.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';

// Provider for location groups (map markers)
final locationsProvider =
    AsyncNotifierProvider<FacultyLocationsNotifier, List<LocationGroup>?>(
      FacultyLocationsNotifier.new,
    );

// Provider for indoor floor plans (building layouts)
final indoorFloorPlansProvider =
    AsyncNotifierProvider<IndoorFloorPlansNotifier, List<IndoorFloorPlan>?>(
      IndoorFloorPlansNotifier.new,
    );

class FacultyLocationsNotifier
    extends CachedAsyncNotifier<List<LocationGroup>> {
  @override
  Duration? get cacheDuration => const Duration(days: 30);

  @override
  Future<List<LocationGroup>> loadFromStorage() {
    return LocationFetcherAsset().getLocations();
  }

  @override
  Future<List<LocationGroup>> loadFromRemote() async {
    try {
      final osmData = await LocationFetcherOSM().getLocations();

      if (osmData.isNotEmpty) {
        return osmData;
      }

      return await loadFromStorage();
    } catch (e) {
      return loadFromStorage();
    }
  }
}

class IndoorFloorPlansNotifier
    extends CachedAsyncNotifier<List<IndoorFloorPlan>> {
  @override
  Duration? get cacheDuration => const Duration(days: 30);

  @override
  Future<List<IndoorFloorPlan>> loadFromStorage() async {
    // TODO: Load from asset JSON as fallback
    return [];
  }

  @override
  Future<List<IndoorFloorPlan>> loadFromRemote() async {
    try {
      return await LocationFetcherOSM().getIndoorFloorPlans();
    } catch (e) {
      return loadFromStorage();
    }
  }
}
