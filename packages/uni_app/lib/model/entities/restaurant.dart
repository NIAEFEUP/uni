import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uni/model/entities/meal.dart';
import 'package:uni/model/utils/day_of_week.dart';

part '../../generated/model/entities/restaurant.g.dart';

@JsonSerializable()
@Entity()
class Restaurant {
  Restaurant(
    this.id,
    this.namePt,
    this.nameEn,
    this.period,
    this.reference, {
    List<Meal> meals = const [],
  }) : meals = ToMany<Meal>() {
    this.meals.addAll(meals);
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  @Id()
  int? uniqueId;

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'namePt')
  final String namePt;
  @JsonKey(name: 'nameEn')
  final String nameEn;
  @JsonKey(name: 'period')
  final String period;
  @JsonKey(name: 'ref')
  final String reference; // Used only in html parser
  @Backlink('restaurant')
  final ToMany<Meal> meals;

  bool get isNotEmpty {
    return meals.isNotEmpty;
  }

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  List<Meal> getMealsOfDay(DayOfWeek dayOfWeek) {
    return groupMealsByDayOfWeek()[dayOfWeek] ?? [];
  }

  Map<DayOfWeek, List<Meal>> groupMealsByDayOfWeek() {
    return groupBy(meals, (meal) => meal.dayOfWeek);
  }
}
