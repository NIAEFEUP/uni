import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/departures_fetcher.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class BusStopProvider extends StateProviderNotifier {
  Map<String, BusStopData> _configuredBusStops = Map.identity();
  DateTime _timeStamp = DateTime.now();

  BusStopProvider() : super(dependsOnSession: false, cacheDuration: null);

  UnmodifiableMapView<String, BusStopData> get configuredBusStops =>
      UnmodifiableMapView(_configuredBusStops);

  DateTime get timeStamp => _timeStamp;

  @override
  Future<void> loadFromStorage() async {
    final AppBusStopDatabase busStopsDb = AppBusStopDatabase();
    final Map<String, BusStopData> stops = await busStopsDb.busStops();
    _configuredBusStops = stops;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    await fetchUserBusTrips();
  }

  Future<void> fetchUserBusTrips() async {
    try {
      for (String stopCode in configuredBusStops.keys) {
        final List<Trip> stopTrips =
            await DeparturesFetcher.getNextArrivalsStop(
                stopCode, configuredBusStops[stopCode]!);
        _configuredBusStops[stopCode]?.trips = stopTrips;
      }
      _timeStamp = DateTime.now();
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get Bus Stop information');
      updateStatus(RequestStatus.failed);
    }
  }

  Future<void> addUserBusStop(String stopCode, BusStopData stopData) async {
    updateStatus(RequestStatus.busy);

    if (_configuredBusStops.containsKey(stopCode)) {
      (_configuredBusStops[stopCode]!.configuredBuses).clear();
      _configuredBusStops[stopCode]!
          .configuredBuses
          .addAll(stopData.configuredBuses);
    } else {
      _configuredBusStops[stopCode] = stopData;
    }

    await fetchUserBusTrips();

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.setBusStops(configuredBusStops);
  }

  Future<void> removeUserBusStop(String stopCode) async {
    updateStatus(RequestStatus.busy);
    _configuredBusStops.remove(stopCode);
    notifyListeners();

    await fetchUserBusTrips();

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.setBusStops(_configuredBusStops);
  }

  Future<void> toggleFavoriteUserBusStop(
      String stopCode, BusStopData stopData) async {
    _configuredBusStops[stopCode]!.favorited =
        !_configuredBusStops[stopCode]!.favorited;
    notifyListeners();

    await fetchUserBusTrips();

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.updateFavoriteBusStop(stopCode);
  }
}
