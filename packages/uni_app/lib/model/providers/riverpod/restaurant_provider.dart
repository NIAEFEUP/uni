import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/controller/fetchers/restaurant_fetcher.dart';
import 'package:uni/controller/local_storage/database/database.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/providers/riverpod/cached_async_notifier.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';

final restaurantProvider =
    AsyncNotifierProvider<RestaurantNotifier, List<Restaurant>?>(
      RestaurantNotifier.new,
    );

class RestaurantNotifier extends CachedAsyncNotifier<List<Restaurant>?> {
  @override
  Duration? get cacheDuration => const Duration(days: 1);

  @override
  Future<List<Restaurant>> loadFromStorage() async {
    return Database().restaurants;
  }

  @override
  Future<List<Restaurant>?> loadFromRemote() async {
    final session = await ref.watch(sessionProvider.future);

    if (session == null) {
      return null;
    }

    try {
      //try to fetch from the internet
      final restaurants = await RestaurantFetcher().getRestaurants(session);

      //if success save to database
      Database().saveRestaurants(restaurants);

      return restaurants;
    } catch (e) {
      //if failure check if we have cached restaurants in the database
      final cachedRestaurants = Database().restaurants;

      if (cachedRestaurants.isNotEmpty) {
        return cachedRestaurants;
      }

      //if no cache, show error
      rethrow;
    }
  }
}
