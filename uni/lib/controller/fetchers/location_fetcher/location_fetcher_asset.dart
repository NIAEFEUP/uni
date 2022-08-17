import 'package:flutter/services.dart' show rootBundle;
import 'package:redux/redux.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/location_group.dart';

class LocationFetcherAsset extends LocationFetcher {
  @override
  Future<List<LocationGroup>> getLocations(Store<AppState> store) async {
    final String json =
        await rootBundle.loadString('assets/text/locations/feup.json');
    return getFromJSON(json);
  }
}
