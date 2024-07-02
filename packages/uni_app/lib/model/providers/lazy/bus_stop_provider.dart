import 'dart:async';

import 'package:uni/controller/fetchers/departures_fetcher.dart';
import 'package:uni/controller/local_storage/database/app_bus_stop_database.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class BusStopProvider extends StateProviderNotifier<Map<String, BusStopData>> {
  BusStopProvider() : super(cacheDuration: null, dependsOnSession: false);

  @override
  Future<Map<String, BusStopData>> loadFromStorage(
    StateProviders stateProviders,
  ) {
    final busStopsDb = AppBusStopDatabase();
    return busStopsDb.busStops();
  }

  @override
  Future<Map<String, BusStopData>> loadFromRemote(
    StateProviders stateProviders,
  ) async {
    return fetchUserBusTrips(state!);
  }

  Future<Map<String, BusStopData>> fetchUserBusTrips(
    Map<String, BusStopData> currentStops,
  ) async {
    for (final stopCode in currentStops.keys) {
      final stopTrips = await DeparturesFetcher.getNextArrivalsStop(
        stopCode,
        currentStops[stopCode]!,
      );
      currentStops[stopCode]?.trips = stopTrips;
    }
    return currentStops;
  }

  Future<void> addUserBusStop(String stopCode, BusStopData stopData) async {
    if (state!.containsKey(stopCode)) {
      state![stopCode]!.configuredBuses.clear();
      state![stopCode]!.configuredBuses.addAll(stopData.configuredBuses);
    } else {
      state![stopCode] = stopData;
    }

    notifyListeners();
    await fetchUserBusTrips(state!);
    notifyListeners();

    final db = AppBusStopDatabase();
    await db.setBusStops(state!);
  }

  Future<void> removeUserBusStop(
    String stopCode,
  ) async {
    state!.remove(stopCode);

    notifyListeners();
    await fetchUserBusTrips(Map.of(state!));
    notifyListeners();

    final db = AppBusStopDatabase();
    await db.setBusStops(state!);
  }

  Future<void> toggleFavoriteUserBusStop(
    String stopCode,
    BusStopData stopData,
  ) async {
    state![stopCode]!.favorited = !state![stopCode]!.favorited;

    notifyListeners();
    await fetchUserBusTrips(state!);
    notifyListeners();

    final db = AppBusStopDatabase();
    await db.updateFavoriteBusStop(stopCode);
  }
}
