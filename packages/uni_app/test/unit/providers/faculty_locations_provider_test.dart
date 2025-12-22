import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/providers/riverpod/faculty_locations_provider.dart';

class FakeLocationFetcher extends LocationFetcherAsset {
  List<LocationGroup> mockedReturn = [];

  @override
  Future<List<LocationGroup>> getLocations() async {
    return mockedReturn;
  }
}

void main() {
  late FakeLocationFetcher fakeFetcher;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    PreferencesController.prefs = await SharedPreferences.getInstance();

    fakeFetcher = FakeLocationFetcher();

    container = ProviderContainer(
      overrides: [
        locationsProvider.overrideWith(
          () => FacultyLocationsNotifier(fetcher: fakeFetcher),
        ),
      ],
    );
    addTearDown(() => container.dispose());
  });

  test('Must load locations with success using a Fake class', () async {
    // O teu JSON estava certinho de acordo com o teu getFromJSON!
    const String rawJson = '''
    {
      "data": [
        {
          "id": 0,
          "lat": 41.17,
          "lng": -8.59,
          "isFloorless": false,
          "locations": {
            "0": [
              {
                "id": 0, 
                "name": "Sala B004", 
                "type": "ROOMS", 
                "args": {"firstRoom":"B004","lastRoom":"B007"}
              }
            ]
          }
        }
      ]
    }
    ''';

    final groups = await fakeFetcher.getFromJSON(rawJson);
    
    fakeFetcher.mockedReturn = groups;

    container.read(locationsProvider);

    await Future.delayed(Duration.zero);

    final finalState = container.read(locationsProvider);

    final data = finalState.value; 

    expect(data, isNotNull); 
    expect(data, isNotEmpty);
    expect(data!.length, 1);
    expect(data.first.id, 0);
  });
}