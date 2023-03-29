import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

import '../../controller/local_storage/app_shared_preferences.dart';

class FacultyLocationsProvider extends StateProviderNotifier {
  List<LocationGroup> _locations = [];

  Map<String, bool> _filteredLocTypes = {};

  UnmodifiableListView<LocationGroup> get locations =>
      UnmodifiableListView(_locations);

  UnmodifiableMapView<String, bool> get filteredLocTypes =>
      UnmodifiableMapView(_filteredLocTypes);

  getFacultyLocations(Completer<void> action) async {
    try {
      updateStatus(RequestStatus.busy);

      _locations = await LocationFetcherAsset().getLocations();

      notifyListeners();
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get locations: ${e.toString()}');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  setFilteredLocations(
      Map<String, bool> newFilteredLocs, Completer<void> action) async {
    _filteredLocTypes = Map<String, bool>.from(newFilteredLocs);
    AppSharedPreferences.saveFilteredLocations(_filteredLocTypes);
    action.complete();
    notifyListeners();
  }
}
