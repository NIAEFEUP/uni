import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uni/model/utils/day_of_week.dart';

part 'meal.g.dart';

class DateTimeConverter extends JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) {
    final DateFormat format = DateFormat('d-M-y');
    return format.parse(json);
  }

  @override
  String toJson(DateTime object) {
    final DateFormat format = DateFormat('d-M-y');
    return format.format(object);
  }
}

@DateTimeConverter()
@JsonSerializable()
class Meal {
  final String type;
  final String name;
  final DayOfWeek dayOfWeek;
  final DateTime date;
  Meal(this.type, this.name, this.dayOfWeek, this.date);

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
  Map<String, dynamic> toJson() => _$MealToJson(this);

  Map<String, dynamic> toMap(restaurantId) {
    final map = toJson();
    map.addEntries(
      {
        'id_restaurant': restaurantId,
      } as Iterable<MapEntry<String, dynamic>>,
    );
    return map;
  }
}
