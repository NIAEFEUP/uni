import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uni/model/utils/day_of_week.dart';

part 'meal.g.dart';

@JsonSerializable()
class Meal {
  final String type;
  final String name;
  final DayOfWeek dayOfWeek;
  final DateTime date;
  Meal(this.type, this.name, this.dayOfWeek, this.date);

  factory Meal.fromJson(Map<String,dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);
}
