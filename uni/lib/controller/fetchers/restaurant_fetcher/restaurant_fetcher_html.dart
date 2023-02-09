import 'package:http/http.dart';
import 'package:uni/controller/fetchers/restaurant_fetcher/restaurant_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_restaurants.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session/sigarra_session.dart';

/// Class for fetching the user's lectures from the schedule's HTML page.
class RestaurantFetcherHtml implements RestaurantFetcher {
  @override
  List<String> getEndpoints(Session session) {
    // TO DO: Implement parsers for all faculties
    // and dispatch for different fetchers
    final url = '${NetworkRouter.getBaseUrl('feup')}CANTINA.EMENTASHOW';
    return [url];
  }

  /// Fetches the user's lectures from the schedule's HTML page.
  @override
  Future<List<Restaurant>> getRestaurants(Session session) async {
    final String baseUrl = getEndpoints(session)[0];
    final Future<Response> response =
        NetworkRouter.getWithCookies(baseUrl, {}, session);
    final List<Restaurant> restaurants =
        await response.then((response) => getRestaurantsFromHtml(response));
    return restaurants;
  }
}
