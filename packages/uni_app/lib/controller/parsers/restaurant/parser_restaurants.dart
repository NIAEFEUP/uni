import 'dart:async';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

/// Reads restaurants's menu from /feup/pt/CANTINA.EMENTASHOW
List<Restaurant> getRestaurantsFromHtml(Response response) {
  try {
    final document = parse(response.body);

    // Get restaurant reference number and name
    final restaurantsHtml = document.querySelectorAll(
      '#conteudoinner ul li > a',
    );

    final restaurantsTuple = restaurantsHtml.map((restaurantHtml) {
      final name = restaurantHtml.text;
      final ref = restaurantHtml.attributes['href']?.replaceAll('#', '');
      return (ref ?? '', name);
    }).toList();

    // Get restaurant meals and create the Restaurant class
    final restaurants = restaurantsTuple.map((restaurantTuple) {
      final meals = <Meal>[];

      final referenceA = document.querySelector(
        'a[name="${restaurantTuple.$1}"]',
      );
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

      return Restaurant(
        null,
        null,
        null,
        restaurantTuple.$2,
        restaurantTuple.$2,
        restaurantTuple.$1,
        2, // Hardcoded to Asprela Campus
        '',
        [],
        '',
        meals: meals,
      );
    }).toList();
    return restaurants;
  } catch (err, st) {
    unawaited(
      Sentry.captureException(
        err,
        stackTrace: st,
        withScope: (s) {
          s
            ..setTag('feature', 'parser_restaurants')
            ..setTag('action', 'parse_sigarra_restaurants');

          final text = response.body.replaceAll(RegExp(r'\s+'), ' ').trim();
          final snippet = text.length > 300 ? text.substring(0, 300) : text;
          s.setContexts('response_snippet', snippet);
        },
      ),
    );
    throw Exception('Failed to parse restaurants from HTML');
  }
}
