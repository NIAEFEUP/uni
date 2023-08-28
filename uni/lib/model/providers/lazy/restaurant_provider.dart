import 'dart:async';
import 'dart:collection';

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
    await fetchRestaurants(session);
  }

  Future<void> fetchRestaurants(Session session) async {
    try {
      final restaurants = await RestaurantFetcher().getRestaurants(session);

      final db = RestaurantDatabase();
      unawaited(db.saveRestaurants(restaurants));

      _restaurants = filterPastMeals(restaurants);

      updateStatus(RequestStatus.successful);
    } catch (e) {
      updateStatus(RequestStatus.failed);
    }
  }
}
