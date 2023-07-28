import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/departures_fetcher.dart';
import 'package:uni/controller/local_storage/app_bus_stop_database.dart';
import 'package:uni/model/entities/bus_stop.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class BusStopProvider extends StateProviderNotifier {
  BusStopProvider() : super(dependsOnSession: false, cacheDuration: null);
  Map<String, BusStopData> _configuredBusStops = Map.identity();
  DateTime _timeStamp = DateTime.now();

  UnmodifiableMapView<String, BusStopData> get configuredBusStops =>
      UnmodifiableMapView(_configuredBusStops);

  DateTime get timeStamp => _timeStamp;

  @override
  Future<void> loadFromStorage() async {
    final busStopsDb = AppBusStopDatabase();
    final stops = await busStopsDb.busStops();
    _configuredBusStops = stops;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    final action = Completer<void>();
    await getUserBusTrips(action);
    await action.future;
  }

  Future<void> getUserBusTrips(Completer<void> action) async {
    updateStatus(RequestStatus.busy);

    try {
      for (final stopCode in configuredBusStops.keys) {
        final stopTrips = await DeparturesFetcher.getNextArrivalsStop(
          stopCode,
          configuredBusStops[stopCode]!,
        );
        _configuredBusStops[stopCode]?.trips = stopTrips;
      }
      _timeStamp = DateTime.now();
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get Bus Stop information');
      updateStatus(RequestStatus.failed);
    }

    action.complete();
  }

  Future<void> addUserBusStop(
    Completer<void> action,
    String stopCode,
    BusStopData stopData,
  ) async {
    updateStatus(RequestStatus.busy);

    if (_configuredBusStops.containsKey(stopCode)) {
      (_configuredBusStops[stopCode]!.configuredBuses).clear();
      _configuredBusStops[stopCode]!
          .configuredBuses
          .addAll(stopData.configuredBuses);
    } else {
      _configuredBusStops[stopCode] = stopData;
    }

    await getUserBusTrips(action);

    final db = AppBusStopDatabase();
    await db.setBusStops(configuredBusStops);
  }

  Future<void> removeUserBusStop(
    Completer<void> action,
    String stopCode,
  ) async {
    updateStatus(RequestStatus.busy);
    _configuredBusStops.remove(stopCode);
    notifyListeners();

    await getUserBusTrips(action);

    final db = AppBusStopDatabase();
    await db.setBusStops(_configuredBusStops);
  }

  Future<void> toggleFavoriteUserBusStop(
    Completer<void> action,
    String stopCode,
    BusStopData stopData,
  ) async {
    _configuredBusStops[stopCode]!.favorited =
        !_configuredBusStops[stopCode]!.favorited;
    notifyListeners();

    await getUserBusTrips(action);

    final db = AppBusStopDatabase();
    await db.updateFavoriteBusStop(stopCode);
  }
}
