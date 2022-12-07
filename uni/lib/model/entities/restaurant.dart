import 'package:collection/collection.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/utils/day_of_week.dart';

class Restaurant {
  final int? id;
  final String name;
  final String reference; // Used only in html parser
  final Map<DayOfWeek, List<Meal>> meals;

  get isNotEmpty {
    return meals.isNotEmpty;
  }

  Restaurant(this.id, this.name, this.reference, {required List<Meal> meals})
      : meals = groupBy(meals, (meal) => meal.dayOfWeek);

  static Restaurant fromMap(Map<String, dynamic> map) {
    return Restaurant(map['id'], map['name'], map['ref'], meals: map['meals']);
  }

  List<Meal> getMealsOfDay(DayOfWeek dayOfWeek) {
    final List<Meal>? meal = meals[dayOfWeek];
    if(meal == null){
      return [];
    }
    return meal;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'ref': reference};
  }
}
