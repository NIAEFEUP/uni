import 'dart:convert';

import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_restaurants.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:up_menus/up_menus.dart';

/// Class for fetching the menu
class RestaurantFetcher {
  final String spreadSheetUrl = 'https://docs.google.com/spreadsheets/d/'
      '1TJauM0HwIf2RauQU2GmhdZZ1ZicFLMHuBkxWwVOw3Q4';
  final String jsonEndpoint = '/gviz/tq?tqx=out:json';

  // Format: Date(dd/mm/yyyy), Meal("Almoço", "Jantar), Dish("Sopa", "Carne",
  //         "Peixe", "Dieta", "Vegetariano", "Salada"), Description(String)
  final String sheetsColumnRange = 'A:D';

  // List the Restaurant sheet names in the Google Sheets Document
  final List<String> restaurantSheets = ['Cantina'];

  // TODO: remove later
  void printRestaurants(List<Restaurant> restaurants) {
    for (final restaurant in restaurants) {
      print(restaurant.id);
      print(restaurant.name);
      print(restaurant.reference);
      final meals = restaurant.meals;
      meals.forEach((day, mealList) {
        print(day);
        for (final meal in mealList) {
          print(' - ${meal.name}');
        }
      });
    }
  }

  // Generate the Gsheets endpoints list based on a list of sheets
  String buildGSheetsEndpoint(String sheet) {
    return Uri.encodeFull(
      '$spreadSheetUrl$jsonEndpoint&sheet=$sheet&range=$sheetsColumnRange',
    );
  }

  String getRestaurantGSheetName(Restaurant restaurant) {
    return restaurantSheets.firstWhere(
      (sheetName) =>
          restaurant.name.toLowerCase().contains(sheetName.toLowerCase()),
      orElse: () => '',
    );
  }

  Future<Restaurant> fetchGSheetsRestaurant(
    String url,
    String restaurantName,
    Session session, {
    bool isDinner = false,
  }) async {
    return getRestaurantFromGSheets(
      await NetworkRouter.getWithCookies(url, {}, session),
      restaurantName,
      isDinner: isDinner,
    );
  }

  Future<List<Restaurant>> getSASUPRestaurants() async {
    // TODO: change to accomodate changes for the new UI.
    final upMenus = UPMenusApi();
    final establishments = await upMenus.establishments.list();
    final restaurants = <Restaurant>[];

    final icbas = await upMenus.establishments.get(4);
    print(icbas.toJson());

    print("74");
    // For every establishement...
    for (final establishment in establishments) {
      // Get the menu for the current week
      if (establishment.dayMenu == false) continue;
      final dayMenus =
          (await upMenus.dayMenus.get(establishment.id, Period.lunch))
              .followedBy(
                await upMenus.dayMenus.get(establishment.id, Period.dinner),
              )
              .followedBy(
                await upMenus.dayMenus.get(establishment.id, Period.snackBar),
              )
              .followedBy(
                await upMenus.dayMenus.get(establishment.id, Period.breakfast),
              );
      print("89");
      print("${establishment.namePt} id: ${establishment.id}");
      final meals = <Meal>[];
      // For every day...
      print("93");
      for (final dayMenu in dayMenus) {
        print("94");
        // And for every dish...
        for (final dish in dayMenu.dishes) {
          // Extract the information about the meal.
          print("96");
          meals.add(
            Meal(
              dish.dishType.namePt,
              dish.dish.namePt,
              parseDateTime(dayMenu.day),
              dayMenu.day,
            ),
          );
        }
      }
      print("110");

      restaurants.add(
        Restaurant(establishment.id, establishment.namePt, '', meals: meals),
      );
      print("115");
      printRestaurants(restaurants);
    }
    print("hereee");
    print(restaurants);
    return restaurants;
  }

  final List<String> sigarraMenuEndpoints = [
    '${NetworkRouter.getBaseUrl('feup')}CANTINA.EMENTASHOW',
  ];

  Future<List<Restaurant>> fetchSigarraRestaurants(Session session) async {
    final restaurants = <Restaurant>[];

    final responses = sigarraMenuEndpoints
        .map((url) => NetworkRouter.getWithCookies(url, {}, session));

    await Future.wait(responses).then((value) {
      for (final response in value) {
        restaurants.addAll(getRestaurantsFromHtml(response));
      }
    });

    return restaurants;
  }

  Future<List<Restaurant>> getRestaurants(Session session) async {
    final restaurants = await getSASUPRestaurants();
    print(restaurants);
    // final restaurants = await fetchSigarraRestaurants(session);

    // Check for restaurants without associated meals and attempt to parse them
    // from GSheets
    final restaurantsWithoutMeals =
        restaurants.where((restaurant) => restaurant.meals.isEmpty).toList();

    for (final restaurant in restaurantsWithoutMeals) {
      final sheetName = getRestaurantGSheetName(restaurant);
      if (sheetName.isEmpty) {
        continue;
      }

      final gSheetsRestaurant = await fetchGSheetsRestaurant(
        buildGSheetsEndpoint(sheetName),
        restaurant.name,
        session,
        isDinner: restaurant.name.toLowerCase().contains('jantar'),
      );

      restaurants
        ..removeWhere(
          (restaurant) => restaurant.name == gSheetsRestaurant.name,
        )
        ..insert(0, gSheetsRestaurant);
    }
    // printRestaurants(restaurants);
    return restaurants;
  }
}
