import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/departures_fetcher.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/trip.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';

class BusStopProvider extends StateProviderNotifier {
  Map<String, BusStopData> _configuredBusStops = Map.identity();
  Map<String, List<Trip>> _currentBusTrips = Map.identity();
  DateTime _timeStamp = DateTime.now();

  UnmodifiableMapView<String, BusStopData> get configuredBusStops =>
      UnmodifiableMapView(_configuredBusStops);

  UnmodifiableMapView<String, List<Trip>> get currentBusTrips =>
      UnmodifiableMapView(_currentBusTrips);

  DateTime get timeStamp => _timeStamp;

  getUserBusTrips(Completer<void> action) async {
    updateStatus(RequestStatus.busy);

    try {
      final Map<String, List<Trip>> trips = <String, List<Trip>>{};

      for (String stopCode in configuredBusStops.keys) {
        final List<Trip> stopTrips =
            await DeparturesFetcher.getNextArrivalsStop(
                stopCode, configuredBusStops[stopCode]!);
        trips[stopCode] = stopTrips;
      }

      final DateTime time = DateTime.now();

      _currentBusTrips = trips;
      _timeStamp = time;
      updateStatus(RequestStatus.successful);
      notifyListeners();
    } catch (e) {
      Logger().e('Failed to get Bus Stop information');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  addUserBusStop(
      Completer<void> action, String stopCode, BusStopData stopData) async {
    updateStatus(RequestStatus.busy);

    if (configuredBusStops.containsKey(stopCode)) {
      (configuredBusStops[stopCode]!.configuredBuses).clear();
      configuredBusStops[stopCode]!
          .configuredBuses
          .addAll(stopData.configuredBuses);
    } else {
      configuredBusStops[stopCode] = stopData;
    }
    notifyListeners();

    getUserBusTrips(action);

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.setBusStops(configuredBusStops);
  }

  removeUserBusStop(Completer<void> action, String stopCode) async {
    updateStatus(RequestStatus.busy);
    _configuredBusStops.remove(stopCode);
    notifyListeners();

    getUserBusTrips(action);

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.setBusStops(_configuredBusStops);
  }

  toggleFavoriteUserBusStop(
      Completer<void> action, String stopCode, BusStopData stopData) async {
    _configuredBusStops[stopCode]!.favorited =
        !_configuredBusStops[stopCode]!.favorited;
    notifyListeners();

    getUserBusTrips(action);

    final AppBusStopDatabase db = AppBusStopDatabase();
    db.updateFavoriteBusStop(stopCode);
  }

  updateStateBasedOnLocalUserBusStops() async {
    final AppBusStopDatabase busStopsDb = AppBusStopDatabase();
    final Map<String, BusStopData> stops = await busStopsDb.busStops();

    _configuredBusStops = stops;
    notifyListeners();
    getUserBusTrips(Completer());
  }
}
