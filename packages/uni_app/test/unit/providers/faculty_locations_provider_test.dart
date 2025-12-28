import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni/controller/fetchers/location_fetcher/location_fetcher_asset.dart';
import 'package:uni/controller/local_storage/preferences_controller.dart';
import 'package:uni/model/entities/location_group.dart';
import 'package:uni/model/entities/locations/room_group_location.dart';
import 'package:uni/model/providers/riverpod/faculty_locations_provider.dart';

class FakeLocationFetcher extends LocationFetcherAsset {
  List<LocationGroup> mockedReturn = [];
  Exception? mockedError;

  @override
  Future<List<LocationGroup>> getLocations() async {
    if (mockedError != null) {
      throw mockedError!;
    }
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

  group('locationsProvider test', () {
    test('Must load locations with success using a Fake class', () async {
      final roomGroup = RoomGroupLocation(
        0,
        'B004',
        'B007',
        locationGroupId: 0,
      );

      final manualGroup = LocationGroup(
        const LatLng(41.17, -8.59),
        id: 0,
        locations: [roomGroup],
      );

      fakeFetcher.mockedReturn = [manualGroup];

      container.read(locationsProvider);

      await Future<void>.delayed(Duration.zero);

      final finalState = container.read(locationsProvider);

      final data = finalState.value;

      expect(data, isNotNull);
      expect(data, isNotEmpty);
      expect(data!.length, 1);
      expect(data.first.id, 0);
      expect(data.first.floors[0]!.first, equals(roomGroup));
    });

    test('Must not crash when given empty values', () async {
      final manualGroup = LocationGroup(const LatLng(0, 0), locations: []);

      fakeFetcher.mockedReturn = [manualGroup];

      container.read(locationsProvider);

      await Future<void>.delayed(Duration.zero);

      final state = container.read(locationsProvider);
      final data = state.value;

      expect(data!.first.floors, isEmpty);
    });

    test('See how provider reacts to possible erros on the fetcher', () async {
      fakeFetcher.mockedError = Exception('Data corruption or Network failure');

      try {
        await container.read(locationsProvider.future);
      } catch (_) {}

      final state = container.read(locationsProvider);
      expect(state.hasError, isTrue);
      expect(
        state.error.toString(),
        contains('Data corruption or Network failure'),
      );
    });

    test('Should emit AsyncLoading state when initialization starts', () {
      final state = container.read(locationsProvider);

      expect(state.isLoading, isTrue);
      expect(state.hasValue, isFalse);
      expect(state, isA<AsyncLoading<List<LocationGroup>?>>());
    });

    test('Provider must reload with new value', () async {
      final manualGroup = LocationGroup(const LatLng(0, 0), locations: []);

      fakeFetcher.mockedReturn = [manualGroup];

      await container.read(locationsProvider.future);

      final newGroup = LocationGroup(const LatLng(0, 0), id: 2, locations: []);

      fakeFetcher.mockedReturn = [newGroup];

      container.invalidate(locationsProvider);
      await container.read(locationsProvider.future);

      final state = container.read(locationsProvider);
      expect(state.value!.first.id, 2);
    });

    test('Must recover from an error to a success state', () async {
      fakeFetcher.mockedError = Exception('Exception');
      try {
        await container.read(locationsProvider.future);
      } catch (_) {}
      expect(container.read(locationsProvider).hasError, isTrue);

      fakeFetcher.mockedError = null;

      final manualGroup = LocationGroup(
        const LatLng(0, 0),
        id: 1,
        locations: [],
      );

      fakeFetcher.mockedReturn = [manualGroup];

      container.invalidate(locationsProvider);
      await container.read(locationsProvider.future);

      final state = container.read(locationsProvider);

      expect(state.value!.first.id, 1);
    });
  });
}
