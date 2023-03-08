import 'package:http/http.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/entities/session.dart';

import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_restaurants.dart';

/// Class for fetching the menu
class RestaurantFetcher {
  String spreadSheetUrl = 'https://docs.google.com/spreadsheets/d/'
      '1TJauM0HwIf2RauQU2GmhdZZ1ZicFLMHuBkxWwVOw3Q4';
  String jsonEndpoint = '/gviz/tq?tqx=out:json';

  // Range containing the meals table
  // Format: Date(dd/mm/yyyy), Meal("Almoço", "Jantar), Dish("Sopa", "Carne",
  //         "Peixe", "Dieta", "Vegetariano", "Salada"), Description(String)
  String range = "A:D";

  // List the Restaurant sheet names in the Google Sheets Document
  List<String> sheets = ['Cantina'];

  List<String> sigarraMenuEndpoints = [
    '${NetworkRouter.getBaseUrl('feup')}CANTINA.EMENTASHOW'
  ];

  // Generate the Gsheets endpoints list based on a list of sheets
  List<Tuple2<String, String>> buildGSheetsEndpoints(List<String> sheets) {
    return sheets
        .map((sheet) => Tuple2(
            "$spreadSheetUrl$jsonEndpoint&sheet=${Uri.encodeComponent(sheet)}&range=${Uri.encodeComponent(range)}",
            sheet))
        .toList();
  }

  Future<List<Restaurant>> getRestaurants(Session session) async {
    final List<Restaurant> restaurants = [];
    final Iterable<Future<Response>> responses = sigarraMenuEndpoints
        .map((url) => NetworkRouter.getWithCookies(url, {}, session));

    await Future.wait(responses).then((value) {
      for (var response in value) {
        restaurants.addAll(getRestaurantsFromHtml(response));
      }
    });

    // Check for restaurants without associated meals and attempt to parse them from GSheets
    final List<Restaurant> restaurantsWithoutMeals =
        restaurants.where((restaurant) => restaurant.meals.isEmpty).toList();

    final List<String> sheetsOfRestaurantsWithFallbackEndpoints = sheets
        .where((sheetName) => restaurantsWithoutMeals
            .where((restaurant) =>
                restaurant.name.toLowerCase().contains(sheetName.toLowerCase()))
            .isNotEmpty)
        .toList();

    // Item order is kept both by List.map and Future.wait, so restaurant names can be retrieved using indexes
    final List<Tuple2<String, String>> fallbackGSheetsEndpoints =
        buildGSheetsEndpoints(sheetsOfRestaurantsWithFallbackEndpoints);

    final Iterable<Future<Response>> gSheetsResponses =
        fallbackGSheetsEndpoints.map((endpointAndName) =>
            NetworkRouter.getWithCookies(endpointAndName.item1, {}, session));

    final List<Restaurant> gSheetsRestaurants = [];
    await Future.wait(gSheetsResponses).then((value) {
      for (var i = 0; i < value.length; i++) {
        gSheetsRestaurants.addAll(getRestaurantsFromGSheets(
            value[i], fallbackGSheetsEndpoints[i].item2));
      }
    });

    // Removes only restaurants that were successfully fetched from GSheets
    for (var gSheetRestaurant in gSheetsRestaurants) {
      restaurants.removeWhere((restaurant) {
        final bool nameMatches = restaurant.name
            .toLowerCase()
            .contains(gSheetRestaurant.name.toLowerCase());

        return nameMatches && restaurant.meals.isEmpty;
      });
    }

    restaurants.insertAll(0, gSheetsRestaurants);

    return restaurants;
  }
}
