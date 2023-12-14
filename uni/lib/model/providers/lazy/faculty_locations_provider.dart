import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class FacultyLocationsProvider
    extends StateProviderNotifier<List<LocationGroup>> {
  FacultyLocationsProvider() : super(cacheDuration: const Duration(days: 30));

  @override
  Future<List<LocationGroup>> loadFromStorage() {
    return LocationFetcherAsset().getLocations();
  }

  @override
  Future<List<LocationGroup>> loadFromRemote(
    Session session,
    Profile profile,
  ) async {
    return state!;
  }
}
