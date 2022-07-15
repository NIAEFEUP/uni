import 'package:collection/collection.dart';
import 'package:uni/model/utils/day_of_week.dart';

import 'meal.dart';

class Restaurant {
  final int? id;
  final String name;
  final String reference; // Used only in html parser
  final Map<DayOfWeek, List<Meal>> meals;

  Restaurant(this.id, this.name, this.reference, {required List<Meal> meals})
      : meals = groupBy(meals, (meal) => meal.dayOfWeek);

  static Restaurant fromMap(Map<String, dynamic> map) {
    return Restaurant(map['id'], map['name'], map['ref'], meals: map['meals']);
  }

  List<Meal> getMealsOfDay(DayOfWeek dayOfWeek) {
    return meals[dayOfWeek]!;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'ref': reference};
  }
}
