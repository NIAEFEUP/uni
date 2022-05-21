import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_restaurants.dart';
import 'package:uni/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';
import 'restaurant_fetcher.dart';

/// Class for fetching the user's lectures from the schedule's HTML page.
class RestaurantFetcherHtml extends RestaurantFetcher {
  /// Fetches the user's lectures from the schedule's HTML page.
  @override
  Future<List<Restaurant>> getRestaurants(Store<AppState> store) async {
    final String baseUrl =
        NetworkRouter.getBaseUrlFromSession(store.state.content['session']) +
            'CANTINA.EMENTASHOW';
    final Session session = store.state.content['session'];
    final Future<Response> response =
        NetworkRouter.getWithCookies(baseUrl, {}, session);
    final List<Restaurant> restaurants =
        await response.then((response) => getRestaurantsFromHtml(response));

    return restaurants;
  }
}
