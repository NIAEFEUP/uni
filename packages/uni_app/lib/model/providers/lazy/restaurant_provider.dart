import 'dart:async';

import 'package:uni/controller/fetchers/restaurant_fetcher.dart';
import 'package:uni/controller/local_storage/database-nosql/restaurants_database.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/state_provider_notifier.dart';
import 'package:uni/model/providers/state_providers.dart';

class RestaurantProvider extends StateProviderNotifier<List<Restaurant>> {
  RestaurantProvider() : super(cacheDuration: const Duration(days: 1));

  @override
  Future<List<Restaurant>> loadFromStorage(
    StateProviders stateProviders,
  ) async {
    return RestaurantsDatabase().getAll();
  }

  @override
  Future<List<Restaurant>> loadFromRemote(StateProviders stateProviders) async {
    final session = stateProviders.sessionProvider.state!;
    final restaurants = await RestaurantFetcher().getRestaurants(session);

    final db = RestaurantsDatabase();
    unawaited(db.saveIfPersistentSession(restaurants));

    return restaurants;
  }
}
