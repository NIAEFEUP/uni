import 'package:flutter/services.dart' show rootBundle;
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher.dart';
import 'package:uni/model/entities/location_group.dart';

class LocationFetcherAsset extends LocationFetcher {
  @override
  Future<List<LocationGroup>> getLocations() async {
    final json = await rootBundle.loadString('assets/text/locations/feup.json');
    return getFromJSON(json);
  }
}
