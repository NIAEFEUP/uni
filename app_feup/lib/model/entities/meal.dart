import 'package:intl/intl.dart';
import 'package:uni/model/entities/restaurant.dart';
import 'package:uni/model/utils/day_of_week.dart';

class Meal{
  String type;
  String name;
  DayOfWeek dayOfWeek;
  DateTime date;
  Restaurant restaurant;
  Meal(this.type, this.name, this.dayOfWeek, this.date, this.restaurant);

  Map<String, dynamic> toMap() {
    final DateFormat format = DateFormat('d-M-y');
    return {
      'id':null,
      'day':toString(this.dayOfWeek),
      'type':this.type,
      'name':this.name,
      'date': this.date != null ? format.format(this.date) : null,
      'id_restaurant':restaurant.id};
  }
}