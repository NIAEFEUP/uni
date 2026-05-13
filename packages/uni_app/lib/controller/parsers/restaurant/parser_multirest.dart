import 'package:html/parser.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

List<Restaurant> parseMultirestHtml(
  String html,
  String institutionName,
  String institutionId,
) {
  final document = parse(html);
  final List<Restaurant> result = [];

  final nameSpan = document.querySelector('.section-heading-upper');
  final displayName = nameSpan?.text.trim() ?? institutionName;

  final mealDivs = document.querySelectorAll('.meal');
  final List<Meal> allMeals = [];

  for (final mealDiv in mealDivs) {
    final dateSpan = mealDiv.querySelector('h3 > span[data-date]');
    if (dateSpan == null) {
      continue;
    }

    final dateStr = dateSpan.attributes['data-date']!;
    final currentDate = DateTime.parse(convertEuropeanDate(dateStr));

    final table = mealDiv.querySelector('table.meal_table');
    if (table == null) {
      continue;
    }

    final rows = table.querySelectorAll('tr');
    for (final row in rows) {
      final typeHeader = row.querySelector('th');
      final dishCell = row.querySelector('td');

      if (typeHeader == null || dishCell == null) {
        continue;
      }

      final type = typeHeader.text.replaceAll(':', '').trim();
      final dishName =
          dishCell.querySelector('a')?.text.trim() ?? dishCell.text.trim();

      if (dishName.isEmpty) {
        continue;
      }

      allMeals.add(
        Meal(
          type,
          dishName,
          dishName,
          currentDate,
          dbDayOfWeek: parseDateTime(currentDate).index,
        ),
      );
    }
  }

  if (allMeals.isNotEmpty) {
    result.add(
      Restaurant(
        null,
        null,
        null,
        displayName,
        displayName,
        institutionId,
        0,
        '',
        [],
        '',
        meals: allMeals,
      ),
    );
  }
  return result;
}

String convertEuropeanDate(String european) {
  final parts = european.split('/');
  if (parts.length != 3) {
    return european;
  }
  return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
}
