import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
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
    return Tuple2(ref ?? '', name);
  }).toList();

  // Get restaurant meals and create the Restaurant class
  final restaurants = restaurantsTuple.map((restaurantTuple) {
    final meals = <Meal>[];

    final referenceA =
        document.querySelector('a[name="${restaurantTuple.item1}"]');
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
              final meal = Meal(type ?? '', value, dayOfWeek!, date!);
              meals.add(meal);
            }
          }
        });
        break;
      }
    }
    return Restaurant(
      null,
      restaurantTuple.item2,
      restaurantTuple.item1,
      meals: meals,
    );
  }).toList();
  return restaurants;
}

Restaurant getRestaurantFromGSheets(
  Response response,
  String restaurantName, {
  bool isDinner = false,
}) {
  // Ignore beginning of response: "/*O_o*/\ngoogle.visualization.Query.setResponse("
  // Ignore the end of the response: ");"
  // Check the structure by accessing the link:
  // https://docs.google.com/spreadsheets/d/1TJauM0HwIf2RauQU2GmhdZZ1ZicFLMHuBkxWwVOw3Q4/gviz/tq?tqx=out:json&sheet=Cantina%20de%20Engenharia&range=A:D
  final jsonString = response.body.substring(
    response.body.indexOf('(') + 1,
    response.body.lastIndexOf(')'),
  );
  final parsedJson = jsonDecode(jsonString) as Map<String, dynamic>;

  final mealsList = <Meal>[];

  final format = DateFormat('d/M/y');

  final table = parsedJson['table'] as Map<String, dynamic>;
  final rows = table['rows'] as List<dynamic>;

  for (final row in rows) {
    final cellList = (row as Map<String, dynamic>)['c'] as List<dynamic>;
    if (((cellList[1] as Map<String, dynamic>)['v'] == 'Almoço' && isDinner) ||
        ((cellList[1] as Map<String, dynamic>)['v'] != 'Almoço' && !isDinner)) {
      continue;
    }

    final meal = Meal(
      (cellList[2] as Map<String, dynamic>)['v'] as String,
      (cellList[3] as Map<String, dynamic>)['v'] as String,
      DayOfWeek.values[format
              .parseUtc((cellList[0] as Map<String, dynamic>)['f'] as String)
              .weekday -
          1],
      format.parseUtc((cellList[0] as Map<String, dynamic>)['f'] as String),
    );
    mealsList.add(meal);
  }

  return Restaurant(null, restaurantName, '', meals: mealsList);
}
