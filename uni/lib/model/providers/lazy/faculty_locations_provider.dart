import 'dart:collection';

import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class FacultyLocationsProvider extends StateProviderNotifier {
  FacultyLocationsProvider()
      : super(dependsOnSession: false, cacheDuration: const Duration(days: 30));
  List<LocationGroup> _locations = [];

  UnmodifiableListView<LocationGroup> get locations =>
      UnmodifiableListView(_locations);

  @override
  Future<void> loadFromStorage() async {
    _locations = await LocationFetcherAsset().getLocations();
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {}
}
