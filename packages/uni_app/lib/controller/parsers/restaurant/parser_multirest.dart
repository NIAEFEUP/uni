import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

List<Restaurant> parseMultirestHtml(String html, String institutionName, String institutionId) {
  final lines = html.split('\n');
  final List<Restaurant> result = [];
  DateTime? currentDate;
  final List<Meal> meals = [];
  final dayHeaderRegex = RegExp(r'^[#]+\s*(\d+)ª Feira - (\d{2}/\d{2}/\d{4})');
  for (final line in lines) {
    final headerMatch = dayHeaderRegex.firstMatch(line);
    if (headerMatch != null) {
      if (currentDate != null && meals.isNotEmpty) {
        result.add(Restaurant(
          null,
          null,
          null,
          institutionName,
          institutionName,
          institutionId,
          0,
          '',
          [],
          '',
          meals: meals,
        ));
        meals.clear();
      }
      final dateStr = headerMatch.group(2)!;
      currentDate = DateTime.parse(convertEuropeanDate(dateStr));
      continue;
    }
    
    if (line.trim().startsWith('[')) {
      final dishNameMatch = RegExp(r'\[(.*?)\]').firstMatch(line);
      if (dishNameMatch == null) {
        continue;
      }
      final dishName = dishNameMatch.group(1)!.trim();
      if (currentDate == null) {
        continue;
      }
      meals.add(Meal(
        'Refeição',
        dishName,
        dishName,
        currentDate,
        dbDayOfWeek: parseDateTime(currentDate).index,
      ));
    }
  }
  if (currentDate != null && meals.isNotEmpty) {
    result.add(Restaurant(
      null,
      null,
      null,
      institutionName,
      institutionName,
      institutionId,
      0,
      '',
      [],
      '',
      meals: meals,
    ));
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
