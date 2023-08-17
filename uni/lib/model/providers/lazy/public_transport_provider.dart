

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/public_transportation_fetchers/explore_porto_api_fetcher.dart';
import 'package:uni/controller/fetchers/public_transportation_fetchers/public_transportation_fetcher.dart';
import 'package:uni/controller/local_storage/app_public_transport_database.dart';
import 'package:uni/model/entities/favorite_trip.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/stop.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class PublicTransportationProvider extends StateProviderNotifier{

  PublicTransportationProvider() : super(dependsOnSession: false, cacheDuration: const Duration(days: 1));
  Map<String, Stop> _stops = {};
  Map<String, Route> _routes = {};

  List<FavoriteTrip> _favoriteTrips = [];

  static List<PublicTransportationFetcher> fetchers = [ExplorePortoAPIFetcher()];

  UnmodifiableListView<FavoriteTrip> getFavoriteTrips() => UnmodifiableListView(_favoriteTrips);

  UnmodifiableMapView<String, Stop> getStops() => UnmodifiableMapView(_stops);

  UnmodifiableMapView<String, Route> getRoutes() => UnmodifiableMapView(_routes);

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    final appPublicTransportDatabase = AppPublicTransportDatabase();
    try{
      for(final fetcher in fetchers){
        final stops = await fetcher.fetchStops();
        //Map.addAll() doesn't work in the first time for some reason, so we do it manually :) 
        for(final stop in stops.entries){
          _stops[stop.key] = stop.value;
        }
        final routes = await fetcher.fetchRoutes(_stops);
        for(final route in routes.entries){
          _routes[route.key] = route.value;
        }
      }
      updateStatus(RequestStatus.successful);
      await appPublicTransportDatabase.insertStops(_stops);
      await appPublicTransportDatabase.insertRoutes(_routes);
      
    }
    catch (e, stack){
      Logger().e('',e,stack);
      updateStatus(RequestStatus.failed);
    }

  }

  @override
  Future<void> loadFromStorage() async {
    final appPublicTransportDatabase = AppPublicTransportDatabase();
    _stops = await appPublicTransportDatabase.stops();
    _routes = await appPublicTransportDatabase.routes(_stops);
    _favoriteTrips = await appPublicTransportDatabase.favoriteTrips(_stops, _routes);
  }

}