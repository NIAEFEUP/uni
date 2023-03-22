import 'package:http/http.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';

import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_restaurants.dart';

/// Class for fetching the menu
class RestaurantFetcher {
  final String spreadSheetUrl = 'https://docs.google.com/spreadsheets/d/'
      '1TJauM0HwIf2RauQU2GmhdZZ1ZicFLMHuBkxWwVOw3Q4';
  final String jsonEndpoint = '/gviz/tq?tqx=out:json';

  // Format: Date(dd/mm/yyyy), Meal("Almoço", "Jantar), Dish("Sopa", "Carne",
  //         "Peixe", "Dieta", "Vegetariano", "Salada"), Description(String)
  final String sheetsColumnRange = "A:D";

  // List the Restaurant sheet names in the Google Sheets Document
  final List<String> restaurantSheets = ['Cantina'];

  // Generate the Gsheets endpoints list based on a list of sheets
  String buildGSheetsEndpoint(String sheet) {
    return Uri.encodeFull(
        "$spreadSheetUrl$jsonEndpoint&sheet=$sheet&range=$sheetsColumnRange");
  }

  String getRestaurantGSheetName(Restaurant restaurant) {
    return restaurantSheets.firstWhere(
        (sheetName) =>
            restaurant.name.toLowerCase().contains(sheetName.toLowerCase()),
        orElse: () => '');
  }

  Future<Restaurant> fetchGSheetsRestaurant(
      String url, String restaurantName, session,
      {isDinner = false}) async {
    return getRestaurantFromGSheets(
        await NetworkRouter.getWithCookies(url, {}, session), restaurantName,
        isDinner: isDinner);
  }

  final List<String> sigarraMenuEndpoints = [
    '${NetworkRouter.getBaseUrl('feup')}CANTINA.EMENTASHOW'
  ];

  Future<List<Restaurant>> fetchSigarraRestaurants(Session session) async {
    final List<Restaurant> restaurants = [];

    final Iterable<Future<Response>> responses = sigarraMenuEndpoints
        .map((url) => NetworkRouter.getWithCookies(url, {}, session));

    await Future.wait(responses).then((value) {
      for (var response in value) {
        restaurants.addAll(getRestaurantsFromHtml(response));
      }
    });

    return restaurants;
  }

  Future<List<Restaurant>> getRestaurants(Session session) async {
    final List<Restaurant> restaurants = await fetchSigarraRestaurants(session);

    // Check for restaurants without associated meals and attempt to parse them from GSheets
    final List<Restaurant> restaurantsWithoutMeals =
        restaurants.where((restaurant) => restaurant.meals.isEmpty).toList();

    for (var restaurant in restaurantsWithoutMeals) {
      final sheetName = getRestaurantGSheetName(restaurant);
      if (sheetName.isEmpty) {
        continue;
      }

      final Restaurant gSheetsRestaurant = await fetchGSheetsRestaurant(
          buildGSheetsEndpoint(sheetName), restaurant.name, session,
          isDinner: restaurant.name.toLowerCase().contains('jantar'));

      restaurants.removeWhere(
          (restaurant) => restaurant.name == gSheetsRestaurant.name);

      restaurants.insert(0, gSheetsRestaurant);
    }

    return restaurants;
  }
}
