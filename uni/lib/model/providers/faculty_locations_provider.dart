import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class FacultyLocationsProvider extends StateProviderNotifier {
  List<LocationGroup> _locations = [];

  UnmodifiableListView<LocationGroup> get locations =>
      UnmodifiableListView(_locations);

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
}
