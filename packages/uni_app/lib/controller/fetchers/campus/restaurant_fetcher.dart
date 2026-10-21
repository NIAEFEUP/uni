import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/restaurant/parser_multirest.dart';
import 'package:uni/controller/parsers/restaurant/parser_restaurants.dart';
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
        final mealsNames = meals.map((meal) => meal.namePt).toList();
        if (!mealsNames.contains(dish.dish.namePt)) {
          meals.add(
            Meal(
              dish.dishType.namePt,
              dish.dish.namePt,
              dish.dish.nameEn ?? dish.dish.namePt,
              dayMenu.day,
              dbDayOfWeek: parseDateTime(dayMenu.day).index,
            ),
          );
        }
      }
    }
    return Restaurant(
      establishment.id,
      establishment.type.namePt,
      establishment.type.nameEn,
      establishment.namePt,
      establishment.nameEn,
      period,
      establishment.campus.id,
      '',
      establishment.schedules
          .map((schedule) => '${schedule.startHour} - ${schedule.finishHour}')
          .toList(),
      establishment.contacts.first.value,
      meals: meals,
    );
  }

  Future<List<Restaurant>> fetchSASUPRestaurants() async {
    // TODO: change the implementation to accommodate changes for the new UI.
    final upMenus = UPMenusApi();
    final establishments = await upMenus.establishments.list();
    final restaurants = <Restaurant>[];

    const periods = [
      {'period': Period.lunch, 'meal': 'lunch'},
      {'period': Period.dinner, 'meal': 'dinner'},
      {'period': Period.snackBar, 'meal': 'snackbar'},
      {'period': Period.breakfast, 'meal': 'breakfast'},
    ];

    for (final establishment in establishments) {
      if (establishment.dayMenu == false) {
        continue;
      }

      for (final period in periods) {
        restaurants.add(
          convertToRestaurant(
            establishment,
            await upMenus.dayMenus.get(
              establishment.id,
              period['period']! as Period,
            ),
            period['meal']! as String,
          ),
        );
      }
    }
    return restaurants;
  }

  final sigarraMenuEndpoints = <String>[
    '${NetworkRouter.getBaseUrl('feup')}CANTINA.EMENTASHOW',
  ];

  Future<List<Restaurant>> fetchSigarraRestaurants(Session session) async {
    final restaurants = <Restaurant>[];

    final responses = sigarraMenuEndpoints.map(
      (url) => NetworkRouter.getWithCookies(url, {}, session),
    );

    await Future.wait(responses).then((value) {
      for (final response in value) {
        final sigarraRestaurants = getRestaurantsFromHtml(response);
        restaurants.addAll(sigarraRestaurants.where((r) => r.period != '4'));
      }
    });

    return restaurants;
  }

  Future<List<Restaurant>> fetchMultirestRestaurants() async {
    final response = await http.get(Uri.parse('http://multirest.eu/meals.php'));
    final mainDoc = parse(response.body);
    final institutionIds = <String>{};

    for (final a in mainDoc.querySelectorAll('a')) {
      final href = a.attributes['href'];
      if (href == null) {
        continue;
      }
      final match = RegExp(r'institution=(\d+)').firstMatch(href);

      if (match != null) {
        final id = match.group(1)!;
        institutionIds.add(id);
      }
    }

    final campusMapping = {
      '1': 3, // FCUP -> Campo Alegre
      '2': 2, // FEP -> Asprela
      '3': 2, // FEUP -> Asprela
      '7': 2, // FPCEUP -> Asprela
      '8': 1, // FDUP -> Baixa
      '9': 2, // FMDUP -> Asprela
      '10': 2, // FMUP -> Asprela
    };

    final List<Restaurant> restaurants = [];
    for (final id in institutionIds) {
      final resp = await http.get(
        Uri.parse('http://multirest.eu/meals.php?institution=$id'),
      );
      final campusId = campusMapping[id] ?? 0;
      final dayRestaurants = parseMultirestHtml(
        resp.body,
        'Institution $id',
        id,
      );

      restaurants.addAll(
        dayRestaurants.map(
          (r) => Restaurant(
            r.id,
            r.typePt,
            r.typeEn,
            r.namePt,
            r.nameEn,
            'lunch',
            campusId,
            r.reference,
            r.openingHours,
            r.email,
            meals: r.meals.toList(),
          ),
        ),
      );
    }
    return restaurants;
  }

  List<Restaurant> filterClosedRestaurants(List<Restaurant> restaurants) {
    final closedLabels = [
      'ENCERRADO',
      'FERIADO',
      'Unidade de Alimentação Encerrada Temporariamente',
    ];
    return restaurants
        .where(
          (restaurant) => restaurant.meals.every(
            (meal) => !closedLabels.contains(meal.namePt),
          ),
        )
        .toList();
  }

  Future<List<Restaurant>> getRestaurants(Session session) async {
    final restaurants =
        await fetchSASUPRestaurants() +
        await fetchSigarraRestaurants(session) +
        await fetchMultirestRestaurants();

    return filterClosedRestaurants(restaurants);
  }
}
