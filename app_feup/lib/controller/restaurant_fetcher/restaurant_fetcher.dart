import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/restaurant.dart';

/// Class for fetching the menu
abstract class RestaurantFetcher {
  Future<List<Restaurant>> getRestaurants(Store<AppState> store);
}
