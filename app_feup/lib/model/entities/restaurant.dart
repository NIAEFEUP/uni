import 'dart:collection';
import 'package:uni/model/utils/day_of_week.dart';

import 'meal.dart';

class Restaurant{
  final int id;
  final String name;
  final String reference; // Used only in html parser
  final HashMap<DayOfWeek, List<Meal>> meals = HashMap<DayOfWeek, List<Meal>>();

  Restaurant(this.id, this.name, this.reference, {List<Meal> meals = null}){
    DayOfWeek.values.forEach((dayOfWeek) => this.meals[dayOfWeek] = []);
    if(meals != null) {
      meals.forEach((meal) {
        this.addMeal(meal);
      });
    }


  }
  static Restaurant fromMap(Map<String, dynamic> map){
    return Restaurant(map['id'], map['name'], map['ref'], meals:map['meals']);
  }



  void addMeal(Meal meal){
    meals[meal.dayOfWeek].add(meal);
  }

  List<Meal> getMealsOfDay(DayOfWeek dayOfWeek){
    return meals[dayOfWeek];
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'ref': reference
    };
  }







}