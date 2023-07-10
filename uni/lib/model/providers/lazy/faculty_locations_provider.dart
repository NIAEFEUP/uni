import 'dart:collection';

import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class FacultyLocationsProvider extends StateProviderNotifier {
  List<LocationGroup> _locations = [];

  FacultyLocationsProvider()
      : super(dependsOnSession: false, cacheDuration: const Duration(days: 30));

  UnmodifiableListView<LocationGroup> get locations =>
      UnmodifiableListView(_locations);

  @override
  Future<void> loadFromStorage() async {
    updateStatus(RequestStatus.busy);
    _locations = await LocationFetcherAsset().getLocations();
    updateStatus(RequestStatus.successful);
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {}
}
