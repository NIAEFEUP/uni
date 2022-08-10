import 'package:uni/controller/location_fetcher/location_fetcher.dart';
import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:flutter/services.dart' show rootBundle;

class LocationFetcherAsset extends LocationFetcher{
  @override
  Future<List<LocationGroup>> getLocations(Store<AppState> store) async {
    final String json = await rootBundle.loadString('assets/text/locations/feup.txt');
    return getFromJSON(json);

  }

}