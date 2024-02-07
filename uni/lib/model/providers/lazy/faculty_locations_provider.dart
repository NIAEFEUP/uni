import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class FacultyLocationsProvider
    extends StateProviderNotifier<List<LocationGroup>> {
  FacultyLocationsProvider()
      : super(cacheDuration: const Duration(days: 30), dependsOnSession: false);

  @override
  Future<List<LocationGroup>> loadFromStorage(StateProviders stateProviders) {
    return LocationFetcherAsset().getLocations();
  }

  @override
  Future<List<LocationGroup>> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    return state!;
  }
}
