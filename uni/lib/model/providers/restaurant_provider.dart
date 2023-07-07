import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/restaurant_fetcher.dart';
import 'package:uni/controller/local_storage/app_restaurant_database.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class RestaurantProvider extends StateProviderNotifier {
  List<Restaurant> _restaurants = [];

  UnmodifiableListView<Restaurant> get restaurants =>
      UnmodifiableListView(_restaurants);

  @override
  Future<void> loadFromStorage() async {
    final RestaurantDatabase restaurantDb = RestaurantDatabase();
    final List<Restaurant> restaurants = await restaurantDb.getRestaurants();
    _restaurants = restaurants;
  }

  void getRestaurantsFromFetcher(
      Completer<void> action, Session session) async {
    try {
      updateStatus(RequestStatus.busy);

      final List<Restaurant> restaurants =
          await RestaurantFetcher().getRestaurants(session);
      // Updates local database according to information fetched -- Restaurants
      final RestaurantDatabase db = RestaurantDatabase();
      db.saveRestaurants(restaurants);
      _restaurants = filterPastMeals(restaurants);
      notifyListeners();
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get Restaurants: ${e.toString()}');
      updateStatus(RequestStatus.failed);
    }
    action.complete();
  }
}
