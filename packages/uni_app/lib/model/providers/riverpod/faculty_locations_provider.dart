import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';

final locationsProvider =
    AsyncNotifierProvider<FacultyLocationsNotifier, List<LocationGroup>?>(
      FacultyLocationsNotifier.new,
    );

class FacultyLocationsNotifier
    extends CachedAsyncNotifier<List<LocationGroup>> {
  FacultyLocationsNotifier({LocationFetcher? fetcher})
    : _fetcher = fetcher; // constructor

  final LocationFetcher? _fetcher;

  LocationFetcher get fetcher =>
      _fetcher ??
      LocationFetcherAsset(); // getter, if _fetcher is null(not a mock) it will use the fetcher as before

  @override
  Duration? get cacheDuration => const Duration(days: 30);

  @override
  Future<List<LocationGroup>> loadFromStorage() {
    return fetcher.getLocations();
  }

  @override
  Future<List<LocationGroup>> loadFromRemote() {
    //since locations are stored in assets, we don't need internet for this.
    return fetcher.getLocations();
  }
}
