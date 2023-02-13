

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/public_transportation_fetchers/explore_porto_api_fetcher.dart';
import 'package:uni/controller/fetchers/public_transportation_fetchers/public_transportation_fetcher.dart';
import 'package:uni/controller/local_storage/app_public_transport_database.dart';
import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class PublicTransportationProvider extends StateProviderNotifier{
  Map<String, Stop> _stops = {};
  Map<String, Route> _routes = {};

  static List<PublicTransportationFetcher> fetchers = [ExplorePortoAPIFetcher()];


  UnmodifiableMapView<String, Stop> getStops() => UnmodifiableMapView(_stops);

  UnmodifiableMapView<String, Route> getRoutes() => UnmodifiableMapView(_routes);

  getPublicTransportsFromFetcher(Completer<void> action) async{
    updateStatus(RequestStatus.busy);
    final AppPublicTransportDatabase appPublicTransportDatabase = AppPublicTransportDatabase();
    try{
      for(PublicTransportationFetcher fetcher in fetchers){
        _stops.addAll(await fetcher.fetchStops());
        _routes.addAll(await fetcher.fetchRoutes(_stops));
      }
      updateStatus(RequestStatus.successful);
      appPublicTransportDatabase.insertStops(_stops);
      appPublicTransportDatabase.insertRoutes(_routes);
      action.complete();
      
    }
    catch (e, stack){
      Logger().e("",e,stack);
      updateStatus(RequestStatus.failed);
      action.completeError(e, stack);
    }
    notifyListeners();

  }

  getPublicTransportsFromLocalStorage() async{
    final AppPublicTransportDatabase appPublicTransportDatabase = AppPublicTransportDatabase();
    _stops = await appPublicTransportDatabase.stops();
    _routes = await appPublicTransportDatabase.routes(_stops);
    notifyListeners();
    
  }

}