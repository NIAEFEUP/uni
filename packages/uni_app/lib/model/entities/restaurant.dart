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
    this.typePt,
    this.typeEn,
    this.namePt,
    this.nameEn,
    this.period,
    this.campusId,
    this.reference,
    this.openingHours,
    this.email, {
    List<Meal> meals = const [],
  }) : meals = ToMany<Meal>() {
    this.meals.addAll(meals);
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    final object = Restaurant.fromJson(map);
    // object.meals = object.groupMealsByDayOfWeek();
    return object;
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  @Id()
  int? uniqueId;

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'typePt')
  final String? typePt;
  @JsonKey(name: 'typeEn')
  final String? typeEn;
  @JsonKey(name: 'namePt')
  final String namePt;
  @JsonKey(name: 'nameEn')
  final String nameEn;
  @JsonKey(name: 'period')
  final String period;
  @JsonKey(name: 'campusId')
  final int campusId;
  @JsonKey(name: 'ref')
  final String reference; // Used only in html parser
  @JsonKey(name: 'hours')
  final List<String> openingHours;
  @JsonKey(name: 'email')
  final String email;
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
