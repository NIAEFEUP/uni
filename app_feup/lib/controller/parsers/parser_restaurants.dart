import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

/**
 * Reads restaurants's menu from /feup/pt/CANTINA.EMENTASHOW
 */
Future<List<Restaurant>> getRestaurantsFromHtml(Response response) async {
  final document = parse(response.body);

  //Get restaurant reference number and name
  final List<Element> restaurantsHtml =
      document.querySelectorAll('#conteudoinner ul li > a');
  final List<Tuple2<String, String>> restaurantsTuple =
      restaurantsHtml.map((restaurantHtml) {
    final String name = restaurantHtml.text;
    final String ref = restaurantHtml.attributes['href'].replaceAll('#', '');
    return Tuple2(ref, name);
  }).toList();

  //Get restaurant meals and create the Restaurant class
  final List<Restaurant> restaurants = restaurantsTuple.map((restaurantTuple) {
    final List<Meal> meals = [];
    final DateFormat format = DateFormat('d-M-y');
    final Element referenceA =
        document.querySelector('a[name="${restaurantTuple.item1}"]');
    Element next = referenceA.nextElementSibling;
    while (next.attributes['name'] == null) {
      next = next.nextElementSibling;
      if (next.classes.contains('dados')) {
        //It's the menu table
        final List<Element> rows = next.querySelectorAll('tr');
        //Check if is empty
        if (rows.length <= 1) {
          break;
        }

        //Read rows, first row is ignored because it's the header
        rows.getRange(1, rows.length).forEach((row) {
          DayOfWeek dayOfWeek;
          String type;
          DateTime date;
          final List<Element> collumns = row.querySelectorAll('td');

          collumns.forEach((collumn) {
            final String value = collumn.text;
            final String header = collumn.attributes['headers'];
            if (header == 'Data') {
              final DayOfWeek d = parseDayOfWeek(value);
              if (d == null) {
                //It's a date
                date = format.parse(value);
              } else {
                dayOfWeek = d;
              }
            } else {
              type = document.querySelector('#${header}').text;
              final Meal meal = Meal(type, value, dayOfWeek, date);
              meals.add(meal);
            }
          });
        });
        break;
      }
    }
    return Restaurant(null, restaurantTuple.item2, restaurantTuple.item1,
        meals: meals);
  }).toList();
  return restaurants;
}
