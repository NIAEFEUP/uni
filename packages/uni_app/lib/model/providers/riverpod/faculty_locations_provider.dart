import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';

final locationsProvider =
    AsyncNotifierProvider<FacultyLocationsNotifier, List<LocationGroup>?>(
      FacultyLocationsNotifier.new,
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
    return state.value!;
  }
}
