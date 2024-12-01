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
  // Auxliary function to print a list of restaurants.
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

  Future<List<Restaurant>> fetchSASUPRestaurants() async {
    // TODO: change the implementation to accomodate changes for the new UI.
    final upMenus = UPMenusApi();
    final establishments = await upMenus.establishments.list();
    final restaurants = <Restaurant>[];

    // For every establishement...
    for (final establishment in establishments) {
      // Get the menu for the current week
      if (establishment.dayMenu == false) {
        continue;
      }
      final dayMenus = (await upMenus.dayMenus.get(
        establishment.id,
        Period.lunch,
      ))
          .followedBy(
            await upMenus.dayMenus.get(
              establishment.id,
              Period.dinner,
              weekNumber: 40,
              year: 2024,
            ),
          )
          .followedBy(
            await upMenus.dayMenus.get(
              establishment.id,
              Period.snackBar,
              weekNumber: 40,
              year: 2024,
            ),
          )
          .followedBy(
            await upMenus.dayMenus.get(
              establishment.id,
              Period.breakfast,
              weekNumber: 40,
              year: 2024,
            ),
          );
      final meals = <Meal>[];
      // For every day...
      for (final dayMenu in dayMenus) {
        // And for every dish...
        for (final dish in dayMenu.dishes) {
          // Extract the information about the meal.
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

      restaurants.add(
        Restaurant(establishment.id, establishment.namePt, '', meals: meals),
      );
    }
    printRestaurants(restaurants);
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
    final restaurants =
        await fetchSASUPRestaurants() + await fetchSigarraRestaurants(session);

    return restaurants;
  }
}
