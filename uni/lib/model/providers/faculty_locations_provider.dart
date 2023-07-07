import 'dart:collection';

import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class FacultyLocationsProvider extends StateProviderNotifier {
  List<LocationGroup> _locations = [];

  UnmodifiableListView<LocationGroup> get locations =>
      UnmodifiableListView(_locations);

  @override
  void loadFromStorage() async {
    _locations = await LocationFetcherAsset().getLocations();
  }
}
