

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/public_transportation_fetchers/explore_porto_api_fetcher.dart';
import 'package:uni/controller/fetchers/public_transportation_fetchers/public_transportation_fetcher.dart';
import 'package:uni/model/entities/route.dart';
import 'package:uni/model/entities/stop.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class PublicTransportationProvider extends StateProviderNotifier{
  final Map<String, Stop> _stops = {};
  final Set<Route> _routes = {};

  static List<PublicTransportationFetcher> fetchers = [ExplorePortoAPIFetcher()];


  UnmodifiableMapView<String, Stop> getStops() => UnmodifiableMapView(_stops);

  UnmodifiableSetView<Route> getRoutes() => UnmodifiableSetView(_routes);

  getPublicTransportsFromFetcher(Completer<void> action) async{
    updateStatus(RequestStatus.busy);
    try{
      for(PublicTransportationFetcher fetcher in fetchers){
        _stops.addAll(await fetcher.fetchStops());
        _routes.addAll(await fetcher.fetchRoutes(_stops));
      }
      Logger().d(_stops);
      updateStatus(RequestStatus.successful);
      action.complete();
      
    }
    catch (e, stack){
      updateStatus(RequestStatus.failed);
      action.completeError(e, stack);
    }
    notifyListeners();

  }

  getPublicTransportsFromLocalStorage() async{
    notifyListeners();
    
  }

}