import 'package:intl/intl.dart';
import 'package:uni/model/utils/day_of_week.dart';

class Meal {
  Meal(this.type, this.name, this.dayOfWeek, this.date);
  final String type;
  final String name;
  final DayOfWeek dayOfWeek;
  final DateTime date;

  Map<String, dynamic> toMap(int restaurantId) {
    final format = DateFormat('d-M-y');
    return {
      'id': null,
      'day': toString(dayOfWeek),
      'type': type,
      'name': name,
      'date': format.format(date),
      'id_restaurant': restaurantId,
    };
  }
}
