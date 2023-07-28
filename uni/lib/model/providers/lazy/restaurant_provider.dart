import 'dart:async';
import 'dart:collection';

import 'package:logger/logger.dart';
import 'package:uni/controller/fetchers/restaurant_fetcher.dart';
import 'package:uni/controller/local_storage/app_restaurant_database.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/request_status.dart';

class RestaurantProvider extends StateProviderNotifier {
  RestaurantProvider()
      : super(dependsOnSession: false, cacheDuration: const Duration(days: 1));
  List<Restaurant> _restaurants = [];

  UnmodifiableListView<Restaurant> get restaurants =>
      UnmodifiableListView(_restaurants);

  @override
  Future<void> loadFromStorage() async {
    final restaurantDb = RestaurantDatabase();
    final restaurants = await restaurantDb.getRestaurants();
    _restaurants = restaurants;
  }

  @override
  Future<void> loadFromRemote(Session session, Profile profile) async {
    final action = Completer<void>();
    await getRestaurantsFromFetcher(action, session);
    await action.future;
  }

  Future<void> getRestaurantsFromFetcher(
    Completer<void> action,
    Session session,
  ) async {
    try {
      updateStatus(RequestStatus.busy);

      final restaurants = await RestaurantFetcher().getRestaurants(session);
      // Updates local database according to information fetched -- Restaurants
      final db = RestaurantDatabase();
      await db.saveRestaurants(restaurants);
      _restaurants = filterPastMeals(restaurants);
      notifyListeners();
      updateStatus(RequestStatus.successful);
    } catch (e) {
      Logger().e('Failed to get Restaurants: $e');
      updateStatus(RequestStatus.failed);
    }
    action.complete();
  }
}
