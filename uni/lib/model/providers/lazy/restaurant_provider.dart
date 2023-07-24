import 'dart:async';
import 'dart:collection';

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
    await fetchRestaurants(session);
  }

  Future<void> fetchRestaurants(Session session) async {
    try {
      final List<Restaurant> restaurants =
      await RestaurantFetcher().getRestaurants(session);
      final RestaurantDatabase db = RestaurantDatabase();
      db.saveRestaurants(restaurants);

      _restaurants = filterPastMeals(restaurants);

      updateStatus(RequestStatus.successful);
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
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

