import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/utils/day_of_week.dart';

part 'restaurant.g.dart';

@JsonSerializable()
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

  factory Restaurant.fromJson(Map<String,dynamic> json) => _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  List<Meal> getMealsOfDay(DayOfWeek dayOfWeek) {
    return meals[dayOfWeek] ?? [];
  }
}
