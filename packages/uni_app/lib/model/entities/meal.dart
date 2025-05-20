import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uni/model/converters/date_time_converter.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

part '../../generated/model/entities/meal.g.dart';

@DateTimeConverter()
@JsonSerializable()
@Entity()
class Meal {
  Meal(
    this.type,
    this.namePt,
    this.nameEn,
    this.date, {
    int? dbDayOfWeek,
  }) : dayOfWeek = DayOfWeek.values[dbDayOfWeek ?? 0];

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  @Id()
  int? id;
  final String type;
  final String namePt;
  final String nameEn;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @Transient()
  late DayOfWeek dayOfWeek;

  int get dbDayOfWeek => dayOfWeek.index;
  set dbDayOfWeek(int? value) {
    dayOfWeek = DayOfWeek.values[value ?? 0];
  }

  final DateTime date;

  final restaurant = ToOne<Restaurant>();

  Map<String, dynamic> toJson() => _$MealToJson(this);

  Map<String, dynamic> toMap(int restaurantId) {
    final map = toJson();
    map['id_restaurant'] = restaurantId;
    return map;
  }
}
