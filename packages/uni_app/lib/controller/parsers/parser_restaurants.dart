import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

/// Reads restaurants's menu from /feup/pt/CANTINA.EMENTASHOW
List<Restaurant> getRestaurantsFromHtml(Response response) {
  final document = parse(response.body);

  // Get restaurant reference number and name
  final restaurantsHtml = document.querySelectorAll('#conteudoinner ul li > a');

  final restaurantsTuple = restaurantsHtml.map((restaurantHtml) {
    final name = restaurantHtml.text;
    final ref = restaurantHtml.attributes['href']?.replaceAll('#', '');
    return (ref ?? '', name);
  }).toList();

  // Get restaurant meals and create the Restaurant class
  final restaurants = restaurantsTuple.map((restaurantTuple) {
    final meals = <Meal>[];

    final referenceA =
        document.querySelector('a[name="${restaurantTuple.$1}"]');
    var next = referenceA?.nextElementSibling;

    final format = DateFormat('d-M-y');
    while (next != null && next.attributes['name'] == null) {
      next = next.nextElementSibling;
      if (next!.classes.contains('dados')) {
        // It's the menu table
        final rows = next.querySelectorAll('tr');
        // Check if is empty
        if (rows.length <= 1) {
          break;
        }

        // Read rows, first row is ignored because it's the header
        rows.getRange(1, rows.length).forEach((row) {
          DayOfWeek? dayOfWeek;
          String? type;
          DateTime? date;
          final columns = row.querySelectorAll('td');

          for (final column in columns) {
            final value = column.text;
            final header = column.attributes['headers'];
            if (header == 'Data') {
              final d = parseDayOfWeek(value);
              if (d == null) {
                // It's a date
                date = format.parseUtc(value);
              } else {
                dayOfWeek = d;
              }
            } else {
              type = document.querySelector('#$header')?.text;
              final meal = Meal(
                type ?? '',
                value,
                value,
                date!,
                dbDayOfWeek: dayOfWeek!.index,
              );
              meals.add(meal);
            }
          }
        });
        break;
      }
    }

    final mealsToMany = ToMany<Meal>(items: meals);

    return Restaurant(
      null,
      restaurantTuple.$2,
      restaurantTuple.$2,
      restaurantTuple.$1,
      '',
      mealsToMany,
    );
  }).toList();
  return restaurants;
}
