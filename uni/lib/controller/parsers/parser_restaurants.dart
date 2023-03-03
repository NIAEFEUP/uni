import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

/// Reads restaurants's menu from /feup/pt/CANTINA.EMENTASHOW
Future<List<Restaurant>> getRestaurantsFromHtml(Response response) async {
  final document = parse(response.body);

  //Get restaurant reference number and name
  final List<Element> restaurantsHtml =
      document.querySelectorAll('#conteudoinner ul li > a');

  List<Tuple2<String, String>> restaurantsTuple =
      restaurantsHtml.map((restaurantHtml) {
    final String name = restaurantHtml.text;
    final String? ref = restaurantHtml.attributes['href']?.replaceAll('#', '');
    return Tuple2(ref ?? '', name);
  }).toList();

  // Hide "Cantinas" and "Grill" from the list of restaurants
  restaurantsTuple = restaurantsTuple
      .where((element) => !(element.item2.contains("Cantina") ||
          element.item2.contains("Grill")))
      .toList();

  //Get restaurant meals and create the Restaurant class
  final List<Restaurant> restaurants = restaurantsTuple.map((restaurantTuple) {
    final List<Meal> meals = [];

    final Element? referenceA =
        document.querySelector('a[name="${restaurantTuple.item1}"]');
    Element? next = referenceA?.nextElementSibling;

    final DateFormat format = DateFormat('d-M-y');
    while (next != null && next.attributes['name'] == null) {
      next = next.nextElementSibling;
      if (next!.classes.contains('dados')) {
        //It's the menu table
        final List<Element> rows = next.querySelectorAll('tr');
        //Check if is empty
        if (rows.length <= 1) {
          break;
        }

        //Read rows, first row is ignored because it's the header
        rows.getRange(1, rows.length).forEach((row) {
          DayOfWeek? dayOfWeek;
          String? type;
          DateTime? date;
          final List<Element> columns = row.querySelectorAll('td');

          for (var column in columns) {
            final String value = column.text;
            final String? header = column.attributes['headers'];
            if (header == 'Data') {
              final DayOfWeek? d = parseDayOfWeek(value);
              if (d == null) {
                //It's a date
                date = format.parse(value);
              } else {
                dayOfWeek = d;
              }
            } else {
              type = document.querySelector('#$header')?.text;
              final Meal meal = Meal(type ?? '', value, dayOfWeek!, date!);
              meals.add(meal);
            }
          }
        });
        break;
      }
    }
    return Restaurant(null, restaurantTuple.item2, restaurantTuple.item1,
        meals: meals);
  }).toList();
  return restaurants;
}

Future<List<Restaurant>> getRestaurantsFromGSheets(
    Response response, String restaurantName) async {
  // Ignore beginning of response: /*O_o*/\ngoogle.visualization.Query.setResponse(
  // Ignore the end of the response: );
  // Check the structure by accessing the link: https://docs.google.com/spreadsheets/d/1TJauM0HwIf2RauQU2GmhdZZ1ZicFLMHuBkxWwVOw3Q4/gviz/tq?tqx=out:json&sheet=Cantina%20de%20Engenharia&range=A:D
  final jsonString = response.body.substring(
      response.body.indexOf('(') + 1, response.body.lastIndexOf(';') - 1);
  final parsedJson = jsonDecode(jsonString);

  final List<Meal> lunchMealsList = [];
  final List<Meal> dinerMealsList = [];

  final DateFormat format = DateFormat('d/M/y');
  final DateTime lastSunday =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday));
  final DateTime nextSunday = DateTime.now()
      .add(Duration(days: DateTime.sunday - DateTime.now().weekday));
  for (var row in parsedJson['table']['rows']) {
    final cell = row['c'];
    final DateTime date = format.parse(cell[0]['f']);
    if (date.isAfter(lastSunday) && date.isBefore(nextSunday)) {
      final Meal newMeal = Meal(
          cell[2]['v'],
          cell[3]['v'],
          DayOfWeek.values[format.parse(cell[0]['f']).weekday - 1],
          format.parse(cell[0]['f']));
      cell[1]['v'] == 'Almoço'
          ? lunchMealsList.add(newMeal)
          : dinerMealsList.add(newMeal);
    }
  }

  return [
    Restaurant(null, '$restaurantName - Almoço', '', meals: lunchMealsList),
    Restaurant(null, '$restaurantName - Jantar', '', meals: dinerMealsList)
  ];
}
