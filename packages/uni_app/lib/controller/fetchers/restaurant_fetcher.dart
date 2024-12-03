import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_restaurants.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:up_menus/up_menus.dart';

/// Class for fetching the menu
class RestaurantFetcher {
  Restaurant convertToRestaurant(
    Establishment establishment,
    Iterable<DayMenu> dayMenus,
    String period,
  ) {
    final meals = <Meal>[];
    for (final dayMenu in dayMenus) {
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
    return Restaurant(
      establishment.id,
      establishment.namePt,
      period,
      '',
      meals: meals,
    );
  }

  Future<List<Restaurant>> fetchSASUPRestaurants() async {
    // TODO: change the implementation to accomodate changes for the new UI.
    final upMenus = UPMenusApi();
    final establishments = await upMenus.establishments.list();
    final restaurants = <Restaurant>[];

    for (final establishment in establishments) {
      if (establishment.dayMenu == false) {
        continue;
      }

      restaurants
        ..add(
          convertToRestaurant(
            establishment,
            await upMenus.dayMenus.get(
              establishment.id,
              Period.lunch,
            ),
            'lunch',
          ),
        )
        ..add(
          convertToRestaurant(
            establishment,
            await upMenus.dayMenus.get(
              establishment.id,
              Period.dinner,
            ),
            'dinner',
          ),
        )
        ..add(
          convertToRestaurant(
            establishment,
            await upMenus.dayMenus.get(
              establishment.id,
              Period.snackBar,
            ),
            'snackbar',
          ),
        )
        ..add(
          convertToRestaurant(
            establishment,
            await upMenus.dayMenus.get(
              establishment.id,
              Period.breakfast,
            ),
            'breakfast',
          ),
        );
    }
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
