import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/restaurant_fetcher.dart';
import 'package:uni/controller/local_storage/app_restaurant_database.dart';
import 'package:uni/controller/local_storage/app_shared_preferences.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class RestaurantProvider extends StateProviderNotifier {
  List<Restaurant> _restaurants = [];
  List<String> _favoriteRestaurants = [];

  RestaurantProvider()
      : super(dependsOnSession: false, cacheDuration: const Duration(days: 1));

  UnmodifiableListView<Restaurant> get restaurants =>
      UnmodifiableListView(_restaurants);

  UnmodifiableListView<String> get favoriteRestaurants =>
      UnmodifiableListView(_favoriteRestaurants);

  @override
  Future<void> loadFromStorage() async {
    final RestaurantDatabase restaurantDb = RestaurantDatabase();
    final List<Restaurant> restaurants = await restaurantDb.getRestaurants();
    _restaurants = restaurants;
    _favoriteRestaurants = await AppSharedPreferences.getFavoriteRestaurants();
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    final Completer<void> action = Completer<void>();
    getRestaurantsFromFetcher(action, session);
    await action.future;
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

  setFavoriteRestaurants(List<String> newFavoriteRestaurants, Completer<void> action) async {
    _favoriteRestaurants = List<String>.from(newFavoriteRestaurants);
    AppSharedPreferences.saveFavoriteRestaurants(favoriteRestaurants);
    action.complete();
    notifyListeners();
  }

  toggleFavoriteRestaurant(String restaurantName, Completer<void> action) async {
    _favoriteRestaurants.contains(restaurantName)
        ? _favoriteRestaurants.remove(restaurantName)
        : _favoriteRestaurants.add(restaurantName);
    notifyListeners();
    AppSharedPreferences.saveFavoriteRestaurants(favoriteRestaurants);
    action.complete();
  }

  void updateStateBasedOnLocalRestaurants() async{
    final RestaurantDatabase restaurantDb = RestaurantDatabase();
    final List<Restaurant> restaurants = await restaurantDb.getRestaurants();
    _restaurants = restaurants;
    notifyListeners();
  }
}

