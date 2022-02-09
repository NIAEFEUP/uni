import 'package:redux/src/store.dart';
import 'package:uni/controller/location_fetcher/location_fetcher.dart';
import 'package:uni/model/app_state.dart';

import 'package:uni/model/entities/location_group.dart';

class LocationFetcherGit extends LocationFetcher{
  @override
  Future<List<LocationGroup>> getLocations(Store<AppState> store) async {
    final String json = '''
      {"data":[{"id":0,"lat":41.177313480642596,"lng":-8.595251441001894,"isFloorless":false,"locations":{"0":[{"type":"VENDING_MACHINE","args":{}},{"type":"COFFEE_MACHINE","args":{}}]}},{"id":1,"lat":41.17734578196972,"lng":-8.595685958862306,"isFloorless":false,"locations":{"0":[{"type":"COFFEE_MACHINE","args":{}},{"type":"VENDING_MACHINE","args":{}}],"1":[{"type":"COFFEE_MACHINE","args":{}},{"type":"VENDING_MACHINE","args":{}}],"2":[{"type":"ATM","args":{}}]}},{"id":2,"lat":41.177446723514294,"lng":-8.596034646034242,"isFloorless":false,"locations":{"0":[{"type":"COFFEE_MACHINE","args":{}},{"type":"VENDING_MACHINE","args":{}}]}}]}
    
    ''';


    return getFromJSON(json);

  }

}