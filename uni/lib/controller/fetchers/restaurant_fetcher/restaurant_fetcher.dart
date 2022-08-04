import 'package:uni/controller/fetchers/session_dependant_fetcher.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';

/// Class for fetching the menu
abstract class RestaurantFetcher extends SessionDependantFetcher {
  Future<List<Restaurant>> getRestaurants(Session session);
}
