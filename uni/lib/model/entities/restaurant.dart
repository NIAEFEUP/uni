import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/utils/day_of_week.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant {
  Restaurant(this.id, this.name, this.reference, {required List<Meal> meals})
      : meals = groupBy(meals, (meal) => meal.dayOfWeek);

  factory Restaurant.fromMap(Map<String, dynamic> map, List<Meal> meals) {
    final object = Restaurant.fromJson(map);
    object.meals = object.groupMealsByDayOfWeek(meals);
    return object;
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'ref')
  final String reference; // Used only in html parser
  late final Map<DayOfWeek, List<Meal>> meals;

  bool get isNotEmpty {
    return meals.isNotEmpty;
  }

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  List<Meal> getMealsOfDay(DayOfWeek dayOfWeek) {
    return meals[dayOfWeek] ?? [];
  }

  Map<DayOfWeek, List<Meal>> groupMealsByDayOfWeek(List<Meal> meals) {
    return groupBy(meals, (meal) => meal.dayOfWeek);
  }
}
